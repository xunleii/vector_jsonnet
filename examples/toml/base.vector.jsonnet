local vector = (import '../../vector.libsonnet').vector;

vector
.global({ data_dir: '/var/lib/vector' })
.components({
  apache_logs: vector.sources.file({
    description:: 'Ingest data by tailing one or more files',

    include: ['/var/log/apache2/*.log'],  // supports globbing
    ignore_older: 86400,  // 1 day
  }),

  apache_parser: vector.transforms.remap({
    drop_on_error: false,
    source: |||
      . |= parse_regex!(.message, r'^(?P<host>[\w.]+) - (?P<user>[\w]+) (?P<bytes_in>[\d]+) [(?P<timestamp>.*)] "(?P<method>[\w]+) (?P<path>.*)" (?P<status>[\d]+) (?P<bytes_out>[\d]+)$'),
    |||,
  }),
  log_to_metric: vector.transforms.log_to_metric({
    description:: 'Extract somes metrics from the parsed logs',

    metrics: [
      { type: 'counter', field: 'message' },
      { type: 'counter', field: 'bytes_out', name: 'bytes_out_total', increment_by_value: true },
      { type: 'gauge', field: 'bytes_out' },
      { type: 'set', field: 'user' },
      { type: 'histogram', field: 'bytes_out', name: 'bytes_out_histogram' },
    ],
  }),
  apache_sampler: vector.transforms.sample({
    rate: 50,  // only keep 50%
  }),
  apache_lua: vector.transforms.lua({
    description:: 'This is only for multiline string purpose... This component do nothing',

    version: '2',
    hooks: {
      process: |||
        function (event, emit)
          -- event.log.field = "value" -- set value of a field
          -- event.log.another_field = nil -- remove field
          -- event.log.first, event.log.second = nil, event.log.first -- rename field

          -- Very important! Emit the processed event.
          emit(event)
        end
      |||,
    },
  }),


  es_cluster: vector.sinks.elasticsearch({
    description:: 'Send structured data to a short-term storage',

    host: 'http://79.12.221.222:9200',  // local or external host
    index: 'vector-%Y-%m-%d',  // daily indices
  }),
  s3_archives: vector.sinks.aws_s3({
    description:: |||
      Send structured data to a cost-effective long-term storage.

      AWS S3 is a good choice for this purpose.
    |||,

    region: 'us-east-1',
    bucket: 'my-log-archives',
    key_prefix: 'date=%Y-%m-%d',  // daily partitions, hive friendly format
    compression: 'gzip',  // compress final objects
    encoding: 'ndjson',  // new line delimited JSON
    batch: {
      max_size: 10000000,  // 10mb uncompressed
    },
  }),
  prometheus: vector.sinks.prometheus_exporter({
    description:: 'Send metrics to Prometheus',

    default_namespace: 'vector',
    buckets: [0.0, 10.0, 100.0, 1000.0, 10000.0, 100001.0],
  }),
})
.pipelines([
  ['apache_logs', 'apache_parser', 'apache_sampler', 'es_cluster'],
  ['apache_logs', 'apache_parser', 's3_archives'],
  ['apache_logs', 'apache_parser', 'log_to_metric', 'prometheus'],
])
