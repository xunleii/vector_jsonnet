local vector = (import '../../vector.libsonnet').vector;

// Elasticsearch / S3 Hybrid Vector Configuration Example
// ------------------------------------------------------------------------------
// This demonstrates a hybrid pipeline, writing data to both Elasticsearch and
// AWS S3. This is advantageous because each storage helps to offset its
// counterpart's weaknesses. You can provision Elasticsearch for performance
// and delegate durability to S3.
vector
.global({ data_dir: '/var/lib/vector' })
.components({
  // Ingest data by tailing one or more files
  // Docs: https://vector.dev/docs/reference/sources/file
  apache_logs: vector.sources.file({
    include: ['/var/log/*.log'],  // supports globbing
    ignore_older: 86400,  // 1 day
  }),

  // Optionally parse, structure and transform data here.
  // Docs: https://vector.dev/docs/reference/transforms

  // Send structured data to Elasticsearch for searching of recent data
  es_cluster: vector.sinks.elasticsearch({
    endpoint: '79.12.221.222:9200',  // local or external host
    doc_type: '_doc',
  }),

  // Send structured data to S3, a durable long-term storage
  s3_archives: vector.sinks.aws_s3({
    region: 'us-east-1',
    bucket: 'my_log_archives',
    compression: 'gzip',
    encoding: { codec: 'json' },
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
