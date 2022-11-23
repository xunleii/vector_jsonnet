{
  sources:: {
    fn(type, o):: { kind:: 'sources', type: type } + o,

    // Collect metrics from Apache’s HTTPD server
    apache_metrics(o={}):: self.fn('apache_metrics', o),

    // Collect Docker container stats for tasks running in AWS ECS and AWS Fargate
    aws_ecs_metrics(o={}):: self.fn('aws_ecs_metrics', o),

    // Collect logs from AWS Kinesis Firehose
    aws_kinesis_firehose(o={}):: self.fn('aws_kinesis_firehose', o),

    // Collect logs from AWS S3
    aws_s3(o={}):: self.fn('aws_s3', o),

    // Collect logs from AWS SQS
    aws_sqs(o={}):: self.fn('aws_sqs', o),

    // Receive logs, metrics, and traces collected by a Datadog Agent
    datadog_agent(o={}):: self.fn('datadog_agent', o),

    // Generate fake log events, which can be useful for testing and demos
    demo_logs(o={}):: self.fn('demo_logs', o),

    // Collect DNS logs from a dnstap-compatible server
    dnstap(o={}):: self.fn('dnstap', o),

    // Collect logs from Docker
    docker_logs(o={}):: self.fn('docker_logs', o),

    // Receive metrics from collected by a EventStoreDB
    eventstoredb_metrics(o={}):: self.fn('eventstoredb_metrics', o),

    // Collect output from a process running on the host
    exec(o={}):: self.fn('exec', o),

    // Collect logs from files
    file(o={}):: self.fn('file', o),

    // Collect logs from a Fluentd or Fluent Bit agent
    fluent(o={}):: self.fn('fluent', o),

    // Fetch observability events from GCP’s PubSub messaging system
    gcp_pubsub(o={}):: self.fn('gcp_pubsub', o),

    // Collect logs from Heroku’s Logplex, the router responsible for receiving logs from your Heroku apps
    heroku_logs(o={}):: self.fn('heroku_logs', o),

    // Collect metric data from the local system
    host_metrics(o={}):: self.fn('host_metrics', o),

    // Collect logs emitted by an HTTP server
    http(o={}):: self.fn('http', o),

    // Expose all log and trace messages emitted by the running Vector instance
    internal_logs(o={}):: self.fn('internal_logs', o),

    // Access to the metrics produced by Vector itself and process them in your Vector pipeline
    internal_metrics(o={}):: self.fn('internal_metrics', o),

    // Collect logs from JournalD
    journald(o={}):: self.fn('journald', o),

    // Collect logs from Kafka
    kafka(o={}):: self.fn('kafka', o),

    // Collect logs from Kubernetes Nodes
    kubernetes_logs(o={}):: self.fn('kubernetes_logs', o),

    // Collect logs from a Logstash agent
    logstash(o={}):: self.fn('logstash', o),

    // Collect metrics from the MongoDB database
    mongodb_metrics(o={}):: self.fn('mongodb_metrics', o),

    // Read observability data from subjects on the NATS messaging system
    nats(o={}):: self.fn('nats', o),

    // Collect metrics from NGINX
    nginx_metrics(o={}):: self.fn('nginx_metrics', o),

    // Collect metrics from the PostgreSQL database
    postgresql_metrics(o={}):: self.fn('postgresql_metrics', o),

    // Collect metrics from Prometheus
    prometheus_remote_write(o={}):: self.fn('prometheus_remote_write', o),

    // Collect metrics via the Prometheus client
    prometheus_scrape(o={}):: self.fn('prometheus_scrape', o),

    // Collect observability data from Redis.
    redis(o={}):: self.fn('redis', o),

    // Collect logs using the socket client
    socket(o={}):: self.fn('socket', o),

    // Receive logs from Splunk
    splunk_hec(o={}):: self.fn('splunk_hec', o),

    // Collect metrics emitted by the StatsD aggregator
    statsd(o={}):: self.fn('statsd', o),

    // Collect logs sent via stdin
    stdin(o={}):: self.fn('stdin', o),

    // Collect logs sent via Syslog
    syslog(o={}):: self.fn('syslog', o),

    // Collect observability data from another Vector instance
    vector(o={}):: self.fn('vector', o),
  },
}
