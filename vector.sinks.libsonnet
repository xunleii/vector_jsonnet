{
  // Sinks batch or stream data out of Vector.
  sinks:: {
    fn(type, o):: {kind:: 'sinks', type: type} + o,
    
    // Batches `log` events to Amazon Web Service's CloudWatch Logs service via the `PutLogEvents` API endpoint.
    aws_cloudwatch_logs(o={}):: self.fn('aws_cloudwatch_logs', o),

    // Streams `metric` events to Amazon Web Service's CloudWatch Metrics service via the `PutMetricData` API endpoint.
    aws_cloudwatch_metrics(o={}):: self.fn('aws_cloudwatch_metrics', o),

    // Batches `log` events to Amazon Web Service's Kinesis Data Firehose via the `PutRecordBatch` API endpoint.
    aws_kinesis_firehose(o={}):: self.fn('aws_kinesis_firehose', o),

    // Batches `log` events to Amazon Web Service's Kinesis Data Stream service via the `PutRecords` API endpoint.
    aws_kinesis_streams(o={}):: self.fn('aws_kinesis_streams', o),

    // Batches `log` events to Amazon Web Service's S3 service via the `PutObject` API endpoint.
    aws_s3(o={}):: self.fn('aws_s3', o),

    // Streams `log` and `metric` events to a blackhole that simply discards data, designed for testing and benchmarking purposes.
    blackhole(o={}):: self.fn('blackhole', o),

    // Batches `log` events to Clickhouse via the `HTTP` Interface.
    clickhouse(o={}):: self.fn('clickhouse', o),

    // Streams `log` and `metric` events to standard output streams, such as STDOUT and STDERR.
    console(o={}):: self.fn('console', o),

    // Streams `log` events to Datadog's logs via the TCP endpoint.
    datadog_logs(o={}):: self.fn('datadog_logs', o),

    // Batches `metric` events to Datadog's metrics service using HTTP API.
    datadog_metrics(o={}):: self.fn('datadog_metrics', o),

    // Batches `log` events to Elasticsearch via the `_bulk` API endpoint.
    elasticsearch(o={}):: self.fn('elasticsearch', o),

    // Streams `log` events to a file.
    file(o={}):: self.fn('file', o),

    // Batches `log` events to Google Cloud Platform's Cloud Storage service via the XML Interface.
    gcp_cloud_storage(o={}):: self.fn('gcp_cloud_storage', o),

    // Batches `log` events to Google Cloud Platform's Pubsub service via the REST Interface.
    gcp_pubsub(o={}):: self.fn('gcp_pubsub', o),

    // Batches `log` events to Google Cloud Platform's Stackdriver Logging service via the REST Interface.
    gcp_stackdriver_logs(o={}):: self.fn('gcp_stackdriver_logs', o),

    // Batches `log` events to Honeycomb via the batch events API.
    honeycomb(o={}):: self.fn('honeycomb', o),

    // Batches `log` events to a generic HTTP endpoint.
    http(o={}):: self.fn('http', o),

    // Batches `log` events to Humio via the HEC API.
    humio_logs(o={}):: self.fn('humio_logs', o),

    // Batches `metric` events to InfluxDB using v1 or v2 HTTP API.
    influxdb_metrics(o={}):: self.fn('influxdb_metrics', o),

    // Streams `log` events to Apache Kafka via the Kafka protocol.
    kafka(o={}):: self.fn('kafka', o),

    // Batches `log` events to LogDna's HTTP Ingestion API.
    logdna(o={}):: self.fn('logdna', o),

    // Batches `log` events to Loki.
    loki(o={}):: self.fn('loki', o),

    // Batches `log` events to New Relic's log service via their log API.
    new_relic_logs(o={}):: self.fn('new_relic_logs', o),

    // Streams `log` events to Papertrail via Syslog.
    papertrail(o={}):: self.fn('papertrail', o),

    // Exposes `metric` events to Prometheus metrics service.
    prometheus(o={}):: self.fn('prometheus', o),

    // Streams `log` events to Apache Pulsar via the Pulsar protocol.
    pulsar(o={}):: self.fn('pulsar', o),

    // Batches `log` events to Sematext via the Elasticsearch API.
    sematext_logs(o={}):: self.fn('sematext_logs', o),

    // Streams `log` events to a socket, such as a TCP, UDP, or UDS socket.
    socket(o={}):: self.fn('socket', o),

    // Batches `log` events to a Splunk's HTTP Event Collector.
    splunk_hec(o={}):: self.fn('splunk_hec', o),

    // Streams `metric` events to StatsD metrics service.
    statsd(o={}):: self.fn('statsd', o),

    // Streams `log` and `metric` events to another downstream `vector` source.
    vector(o={}):: self.fn('vector', o),
  },
}
