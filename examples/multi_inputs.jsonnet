local vector = (import '../vector.libsonnet').vector;

vector
.global({
  enable_description:: true,
  data_dir: '/var/lib/vector',
})

.components({
  // Sources specify data sources and are responsible for ingesting data into Vector.
  apache_logs: vector.sources.file({
    description:: 'Ingest data by tailing one or more files',
    include: ['/var/log/apache2/*.log'],  // supports globbing
    ignore_older: 86400,  // 1 day
  }),
  nginx: vector.sources.file({
    description:: 'Ingest data by tailing one or more files',
    include: ['/var/log/nginx/*.log'],  // supports globbing
    ignore_older: 86400,  // 1 day
  }),

  // Transforms parse, structure, and enrich events.
  apache_parser: vector.transforms.regex_parser({
    description:: 'Structure and parse the data',
    regex: '^(?P<host>[w.]+) - (?P<user>[w]+) (?P<bytes_in>[d]+) [(?P<timestamp>.*)] "(?P<method>[w]+) (?P<path>.*)" (?P<status>[d]+) (?P<bytes_out>[d]+)$',
  }),
  sampler: vector.transforms.sampler({
    description:: 'Sample the data to save on cost',
    rate: 50,  // only keep 50%
  }),

  // Sinks batch or stream data out of Vector.
  es_cluster: vector.sinks.elasticsearch({
    description:: 'Send structured data to a short-term storage',
    host: 'http://79.12.221.222:9200',  // local or external host
    index: 'vector-%Y-%m-%d',  // daily indices
  }),
  s3_archives: vector.sinks.aws_s3({
    description:: 'Send structured data to a cost-effective long-term storage',
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
  ['nginx', 'sampler', 'es_cluster'],
  ['apache_logs', 'apache_parser', 'sampler', 'es_cluster'],
  ['apache_logs', 'apache_parser', 's3_archives'],
])

.json
