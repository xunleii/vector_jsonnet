{
  sinks:: {
    fn(type, o):: { kind:: 'sinks', type: type } + o,

    // Publish log events to AWS Cloudwatch Logs
    aws_cloudwatch_logs(o={}):: self.fn('aws_cloudwatch_logs', o),

    // Publish metric events to AWS Cloudwatch Metrics
    aws_cloudwatch_metrics(o={}):: self.fn('aws_cloudwatch_metrics', o),

    // Publish logs to AWS Kinesis Data Firehose topics
    aws_kinesis_firehose(o={}):: self.fn('aws_kinesis_firehose', o),

    // Publish logs to AWS Kinesis Streams topics
    aws_kinesis_streams(o={}):: self.fn('aws_kinesis_streams', o),

    // Store observability events in the AWS S3 object storage system
    aws_s3(o={}):: self.fn('aws_s3', o),

    // Publish observability events to Simple Queue Service topics
    aws_sqs(o={}):: self.fn('aws_sqs', o),

    // Store your observability data in Azure Blob Storage
    azure_blob(o={}):: self.fn('azure_blob', o),

    // Publish log events to the Azure Monitor Logs service
    azure_monitor_logs(o={}):: self.fn('azure_monitor_logs', o),

    // Send observability events nowhere, which can be useful for debugging purposes
    blackhole(o={}):: self.fn('blackhole', o),

    // Deliver log data to the Clickhouse database
    clickhouse(o={}):: self.fn('clickhouse', o),

    // Display observability events in the console, which can be useful for debugging purposes
    console(o={}):: self.fn('console', o),

    // Publish observability events to the Datadog Events API
    datadog_events(o={}):: self.fn('datadog_events', o),

    // Publish log events to Datadog
    datadog_logs(o={}):: self.fn('datadog_logs', o),

    // Publish metric events to Datadog
    datadog_metrics(o={}):: self.fn('datadog_metrics', o),

    // Publish traces to Datadog
    datadog_traces(o={}):: self.fn('datadog_traces', o),

    // Index observability events in Elasticsearch
    elasticsearch(o={}):: self.fn('elasticsearch', o),

    // Output observability events into files
    file(o={}):: self.fn('file', o),

    // Deliver metrics to GCP’s Cloud Monitoring system
    gcp_stackdriver_metrics(o={}):: self.fn('gcp_stackdriver_metrics', o),

    // Store observability events in GCP Cloud Storage
    gcp_cloud_storage(o={}):: self.fn('gcp_cloud_storage', o),

    // Deliver logs to GCP’s Cloud Operations suite
    gcp_stackdriver_logs(o={}):: self.fn('gcp_stackdriver_logs', o),

    // Publish observability events to GCP’s PubSub messaging system
    gcp_pubsub(o={}):: self.fn('gcp_pubsub', o),

    // Deliver log events to Honeycomb
    honeycomb(o={}):: self.fn('honeycomb', o),

    // Deliver observability event data to an HTTP server
    http(o={}):: self.fn('http', o),

    // Deliver log event data to Humio
    humio_logs(o={}):: self.fn('humio_logs', o),

    // Deliver metric event data to Humio
    humio_metrics(o={}):: self.fn('humio_metrics', o),

    // Deliver log event data to InfluxDB
    influxdb_logs(o={}):: self.fn('influxdb_logs', o),

    // Deliver metric event data to InfluxDB
    influxdb_metrics(o={}):: self.fn('influxdb_metrics', o),

    // Publish observability event data to Apache Kafka topics
    kafka(o={}):: self.fn('kafka', o),

    // Deliver log event data to LogDNA
    logdna(o={}):: self.fn('logdna', o),

    // Deliver log event data to the Loki aggregation system
    loki(o={}):: self.fn('loki', o),

    // Publish observability data to subjects on the NATS messaging system
    nats(o={}):: self.fn('nats', o),

    // Deliver events to New Relic
    new_relic(o={}):: self.fn('new_relic', o),

    // Deliver log events to New Relic
    new_relic_logs(o={}):: self.fn('new_relic_logs', o),

    // Deliver log events to Papertrail from SolarWinds
    papertrail(o={}):: self.fn('papertrail', o),

    // Output metric events to a Prometheus exporter running on the host
    prometheus_exporter(o={}):: self.fn('prometheus_exporter', o),

    // Deliver metric data to a Prometheus remote write endpoint
    prometheus_remote_write(o={}):: self.fn('prometheus_remote_write', o),

    // Publish observability events to Apache Pulsar topics
    pulsar(o={}):: self.fn('pulsar', o),

    // Publish observability data to Redis.
    redis(o={}):: self.fn('redis', o),

    // Publish log events to Sematext
    sematext_logs(o={}):: self.fn('sematext_logs', o),

    // Publish metric events to Sematext
    sematext_metrics(o={}):: self.fn('sematext_metrics', o),

    // Deliver logs to a remote socket endpoint
    socket(o={}):: self.fn('socket', o),

    // Deliver log data to Splunk’s HTTP Event Collector
    splunk_hec_logs(o={}):: self.fn('splunk_hec_logs', o),

    // Deliver metric data to Splunk’s HTTP Event Collector
    splunk_hec_metrics(o={}):: self.fn('splunk_hec_metrics', o),

    // Deliver metric data to a StatsD aggregator
    statsd(o={}):: self.fn('statsd', o),

    // Relay observability data to another Vector instance
    vector(o={}):: self.fn('vector', o),

    // Deliver observability event data to a websocket listener
    websocket(o={}):: self.fn('websocket', o),
  },
}
