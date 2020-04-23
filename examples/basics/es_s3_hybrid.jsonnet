local vector = (import '../../vector.libsonnet').vector;

vector
.global({ data_dir: '/var/lib/vector' })
.components({
  // Sources specify data sources and are responsible for ingesting data into Vector.
  apache_logs: vector.sources.file({
    include: ['/var/log/*.log'],  // supports globbing
    ignore_older: 86400,  // 1 day
  }),

  // Sinks batch or stream data out of Vector.
  es_cluster: vector.sinks.elasticsearch({
    host: '79.12.221.222:9200',  // local or external host
    doc_type: '_doc',
  }),
  s3_archives: vector.sinks.aws_s3({
    region: 'us-east-1',
    bucket: 'my_log_archives',
    compression: 'gzip',
    encoding: 'ndjson',
    batch: {
      max_size: 10000000,  // 10mb uncompressed
    },
  }),
})
.pipelines([
  ['apache_logs', 'es_cluster'],
  ['apache_logs', 's3_archives'],
])
.json
