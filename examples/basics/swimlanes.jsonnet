local vector = (import '../../vector.libsonnet').vector;

vector
.global({ data_dir: '/var/lib/vector' })
.components({
  // Sources specify data sources and are responsible for ingesting data into Vector.
  apache_logs: vector.sources.file({
    include: ['/var/log/apache2/*.log'],  // supports globbing
    ignore_older: 86400,  // 1 day
  }),

  // Transforms parse, structure, and enrich events.
  apache_parser: vector.transforms.regex_parser({
    regex: '^(?P<host>[w.]+) - (?P<user>[w]+) (?P<bytes_in>[d]+) [(?P<timestamp>.*)] "(?P<method>[w]+) (?P<path>.*)" (?P<status>[d]+) (?P<bytes_out>[d]+)$',
  }),
  sampler: vector.transforms.sampler({ rate: 50 }),
  apache_status: vector.transforms.swimlanes({
    lanes: {
      '2xx': { 'status.regex': '2..' },
      '3xx': { 'status.regex': '3..' },
      '4xx': { 'status.regex': '4..' },
      '5xx': { 'status.regex': '5..' },
    },
  }),

  // Sinks batch or stream data out of Vector.
  es_cluster: vector.sinks.elasticsearch({
    host: 'http://79.12.221.222:9200',  // local or external host
    index: 'vector-%Y-%m-%d',  // daily indices
  }),
  s3_archives: vector.sinks.aws_s3({
    region: 'us-east-1',
    bucket: 'my-log-archives',
    key_prefix: 'date=%Y-%m-%d',  // daily partitions, hive friendly format
    compression: 'gzip',  // compress final objects
    encoding: 'ndjson',  // new line delimited JSON
    batch: {
      max_size: 10000000,  // 10mb uncompressed
    },
  }),
})
.pipelines([
  ['apache_logs', 'apache_parser', 'apache_status.2xx', 'sampler', 'es_cluster'],
  ['apache_logs', 'apache_parser', 'apache_status.3xx', 'sampler', 'es_cluster'],
  ['apache_logs', 'apache_parser', 'apache_status.4xx', 'es_cluster'],
  ['apache_logs', 'apache_parser', 'apache_status.5xx', 'es_cluster'],

  ['apache_logs', 'apache_parser', 'apache_status.2xx', 's3_archives'],
  ['apache_logs', 'apache_parser', 'apache_status.4xx', 's3_archives'],
])
.json