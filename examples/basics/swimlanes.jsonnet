local vector = (import '../../vector.libsonnet').vector;

// Swimlane transform example
// ------------------------------------------------------------------------------
// A simple example that demonstrates the Vector's swimlane mechanism
// with the Jsonnet Library.
vector
.global({ data_dir: '/var/lib/vector' })
.components({
  // Ingest data by tailing one or more files
  apache_logs: vector.sources.file({
    include: ['/var/log/apache2/*.log'],  // supports globbing
    ignore_older: 86400,  // 1 day
  }),

  // Structure and parse the data
  apache_parser: vector.transforms.regex_parser({
    regex: '^(?P<host>[w.]+) - (?P<user>[w]+) (?P<bytes_in>[d]+) [(?P<timestamp>.*)] "(?P<method>[w]+) (?P<path>.*)" (?P<status>[d]+) (?P<bytes_out>[d]+)$',
  }),

  // Create one swimlane for each HTTP Status group
  apache_status: vector.transforms.swimlanes({
    lanes: {
      '2xx': { 'status.regex': '2..' },
      '3xx': { 'status.regex': '3..' },
      '4xx': { 'status.regex': '4..' },
      '5xx': { 'status.regex': '5..' },
    },
  }),

  // Sample the data to save on cost (only 2xx and 3xx)
  sampler: vector.transforms.sampler({ rate: 50 }),

  // Send structured data to a short-term storage
  es_cluster: vector.sinks.elasticsearch({
    host: 'http://79.12.221.222:9200',  // local or external host
    index: 'vector-%Y-%m-%d',  // daily indices
  }),

  // Send structured data to a cost-effective long-term storage
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
