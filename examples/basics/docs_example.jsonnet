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
  apache_sampler: vector.transforms.sampler({
    rate: 50,  // only keep 50%
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
  ['apache_logs', 'apache_parser', 'apache_sampler', 'es_cluster'],
  ['apache_logs', 'apache_parser', 's3_archives'],
])
.json
