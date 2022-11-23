local vector = (import '../../vector.libsonnet').vector;

// Route transform example
// ------------------------------------------------------------------------------
// A simple example that demonstrates the Vector's route mechanism
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
  apache_parser: vector.transforms.remap({
    drop_on_error: false,
    source: |||
      . |= parse_regex!(.message, r'^(?P<host>[\w.]+) - (?P<user>[\w]+) (?P<bytes_in>[\d]+) [(?P<timestamp>.*)] "(?P<method>[\w]+) (?P<path>.*)" (?P<status>[\d]+) (?P<bytes_out>[\d]+)$'),
    |||,
  }),

  // Create one route for each HTTP Status group
  apache_status: vector.transforms.route({
    route: {
      '2xx': 'starts_with(.status, "2")',
      '3xx': 'starts_with(.status, "3")',
      '4xx': 'starts_with(.status, "4")',
      '5xx': 'starts_with(.status, "5")',
    },
  }),

  // Sample the data to save on cost (only 2xx and 3xx)
  sampler: vector.transforms.sample({ rate: 50 }),

  // Send structured data to a short-term storage
  es_cluster: vector.sinks.elasticsearch({
    endpoint: 'http://79.12.221.222:9200',  // local or external host
    bulk: {
      index: 'vector-%Y-%m-%d',  // daily indices
    },
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

  devnull: vector.sinks.blackhole({
  }),
})
.pipelines([
  ['apache_logs', 'apache_parser', 'apache_status.2xx', 'sampler', 'es_cluster'],
  ['apache_logs', 'apache_parser', 'apache_status.3xx', 'sampler', 'es_cluster'],
  ['apache_logs', 'apache_parser', 'apache_status.4xx', 'es_cluster'],
  ['apache_logs', 'apache_parser', 'apache_status.5xx', 'es_cluster'],

  ['apache_logs', 'apache_parser', 'apache_status.2xx', 's3_archives'],
  ['apache_logs', 'apache_parser', 'apache_status.4xx', 's3_archives'],

  ['apache_logs', 'apache_parser', 'apache_status._unmatched', 'devnull'],
])
.json
