{
  sinks:: {
    fn(type, o):: { kind:: 'sinks', type: type } + o,

    // Amazon CloudWatch is a monitoring and management service that provides data and actionable insights for AWS, hybrid, and on-premises applications, and infrastructure resources. With CloudWatch, you can collect and access all your performance and operational data in form of logs and metrics from a single platform.
    aws_cloudwatch_logs(o={}):: self.fn('aws_cloudwatch_logs', o),

    // Amazon CloudWatch is a monitoring and management service that provides data and actionable insights for AWS, hybrid, and on-premises applications, and infrastructure resources. With CloudWatch, you can collect and access all your performance and operational data in form of logs and metrics from a single platform.
    aws_cloudwatch_metrics(o={}):: self.fn('aws_cloudwatch_metrics', o),

    // Amazon Kinesis Data Firehose is a fully managed service for delivering real-time streaming data to destinations such as Amazon Simple Storage Service (Amazon S3), Amazon Redshift, Amazon Elasticsearch Service (Amazon ES), and Splunk.
    aws_kinesis_firehose(o={}):: self.fn('aws_kinesis_firehose', o),

    // Amazon Kinesis Data Streams is a scalable and durable real-time data streaming service that can continuously capture gigabytes of data per second from hundreds of thousands of sources. Making it an excellent candidate for streaming logs and metrics data.
    aws_kinesis_streams(o={}):: self.fn('aws_kinesis_streams', o),

    // Amazon Simple Storage Service (Amazon S3) is a scalable, high-speed, web-based cloud storage service designed for online backup and archiving of data and applications on Amazon Web Services. It is very commonly used to store log data.
    aws_s3(o={}):: self.fn('aws_s3', o),

    // Amazon Simple Queue Service (SQS) is a fully managed message queuing service that enables you to decouple and scale microservices, distributed systems, and serverless applications.
    aws_sqs(o={}):: self.fn('aws_sqs', o),

    // Azure Monitor is a service in Azure that provides performance and availability monitoring for applications and services in Azure, other cloud environments, or on-premises. Azure Monitor collects data from multiple sources into a common data platform where it can be analyzed for trends and anomalies.
    azure_monitor_logs(o={}):: self.fn('azure_monitor_logs', o),

    // The Vector blackhole sink sends logs
    blackhole(o={}):: self.fn('blackhole', o),

    // ClickHouse is an open-source column-oriented database management system that manages extremely large volumes of data, including non-aggregated data, in a stable and sustainable manner and allows generating custom data reports in real time. The system is linearly scalable and can be scaled up to store and process trillions of rows and petabytes of data. This makes it an best-in-class storage for logs and metrics data.
    clickhouse(o={}):: self.fn('clickhouse', o),

    // The Vector console sink sends logs and metrics to STDOUT.
    console(o={}):: self.fn('console', o),

    // Datadog is a monitoring service for cloud-scale applications, providing monitoring of servers, databases, tools, and services, through a SaaS-based data analytics platform.
    datadog_logs(o={}):: self.fn('datadog_logs', o),

    // Datadog is a monitoring service for cloud-scale applications, providing monitoring of servers, databases, tools, and services, through a SaaS-based data analytics platform.
    datadog_metrics(o={}):: self.fn('datadog_metrics', o),

    // Elasticsearch is a search engine based on the Lucene library. It provides a distributed, multitenant-capable full-text search engine with an HTTP web interface and schema-free JSON documents. As a result, it is very commonly used to store and analyze log data. It ships with Kibana which is a simple interface for visualizing and exploring data in Elasticsearch.
    elasticsearch(o={}):: self.fn('elasticsearch', o),

    // The Vector file sink sends logs
    file(o={}):: self.fn('file', o),

    // Google Cloud Storage is a RESTful online file storage web service for storing and accessing data on Google Cloud Platform infrastructure. The service combines the performance and scalability of Google's cloud with advanced security and sharing capabilities. This makes it a prime candidate for log data.
    gcp_cloud_storage(o={}):: self.fn('gcp_cloud_storage', o),

    // GCP Pub/Sub is a fully-managed real-time messaging service that allows you to send and receive messages between independent applications on the Google Cloud Platform.
    gcp_pubsub(o={}):: self.fn('gcp_pubsub', o),

    // Stackdriver is Google Cloud's embedded observability suite designed to monitor, troubleshoot, and improve cloud infrastructure, software and application performance. Stackdriver enables you to efficiently build and run workloads, keeping applications available and performing well.
    gcp_stackdriver_logs(o={}):: self.fn('gcp_stackdriver_logs', o),

    // Honeycomb provides full stack observability—designed for high cardinality data and collaborative problem solving, enabling engineers to deeply understand and debug production software together.
    honeycomb(o={}):: self.fn('honeycomb', o),

    // Batches log events to a generic HTTP endpoint.
    http(o={}):: self.fn('http', o),

    // Humio is a time-series logging and aggregation platform for unrestricted, comprehensive event analysis, On-Premises or in the Cloud. With 1TB/day of raw log ingest/node, in-memory stream processing, and live, shareable dashboards and alerts, you can instantly and in real-time explore, monitor, and visualize any system’s data. Metrics are converted to log events via the metric_to_log transform.
    humio_logs(o={}):: self.fn('humio_logs', o),

    // Humio is a time-series logging and aggregation platform for unrestricted, comprehensive event analysis, On-Premises or in the Cloud. With 1TB/day of raw log ingest/node, in-memory stream processing, and live, shareable dashboards and alerts, you can instantly and in real-time explore, monitor, and visualize any system’s data. Metrics are converted to log events via the metric_to_log transform.
    humio_metrics(o={}):: self.fn('humio_metrics', o),

    // InfluxDB is an open-source time series database developed by InfluxData. It is written in Go and optimized for fast, high-availability storage and retrieval of time series data in fields such as operations monitoring, application metrics, Internet of Things sensor data, and real-time analytics.
    influxdb_logs(o={}):: self.fn('influxdb_logs', o),

    // InfluxDB is an open-source time series database developed by InfluxData. It is written in Go and optimized for fast, high-availability storage and retrieval of time series data in fields such as operations monitoring, application metrics, Internet of Things sensor data, and real-time analytics.
    influxdb_metrics(o={}):: self.fn('influxdb_metrics', o),

    // Apache Kafka is an open-source project for a distributed publish-subscribe messaging system rethought as a distributed commit log. Kafka stores messages in topics that are partitioned and replicated across multiple brokers in a cluster. Producers send messages to topics from which consumers read. These features make it an excellent candidate for durably storing logs and metrics data.
    kafka(o={}):: self.fn('kafka', o),

    // LogDNA is a log management system that allows engineering and DevOps to aggregate all system, server, and application logs into one platform. Collect, monitor, store, tail, and search application logs in with one command-line or web interface.
    logdna(o={}):: self.fn('logdna', o),

    // Loki is a horizontally-scalable, highly-available, multi-tenant log aggregation system inspired by Prometheus. It is designed to be very cost effective and easy to operate. It does not index the contents of the logs, but rather a set of labels for each log stream.
    loki(o={}):: self.fn('loki', o),

    // NATS.io is a simple, secure and high performance open source messaging system for cloud native applications, IoT messaging, and microservices architectures. NATS.io is a Cloud Native Computing Foundation project.
    nats(o={}):: self.fn('nats', o),

    // New Relic is a San Francisco, California-based technology company which develops cloud-based software to help website and application owners track the performances of their services.
    new_relic_logs(o={}):: self.fn('new_relic_logs', o),

    // Papertrail is a web-based log aggregation application used by developers and IT team to search and view logs in real time.
    papertrail(o={}):: self.fn('papertrail', o),

    // Prometheus is a pull-based monitoring system that scrapes metrics from configured endpoints, stores them efficiently, and supports a powerful query language to compose dynamic information from a variety of otherwise unrelated data points.
    prometheus_exporter(o={}):: self.fn('prometheus_exporter', o),

    // Prometheus is a monitoring system that scrapes metrics from configured endpoints, stores them efficiently, and supports a powerful query language to compose dynamic information from a variety of otherwise unrelated data points.
    prometheus_remote_write(o={}):: self.fn('prometheus_remote_write', o),

    // Pulsar is a multi-tenant, high-performance solution for server-to-server messaging. Pulsar was originally developed by Yahoo, it is under the stewardship of the Apache Software Foundation. It is an excellent tool for streaming logs and metrics data.
    pulsar(o={}):: self.fn('pulsar', o),

    // Sematext is a hosted monitoring platform based on Elasticsearch. Providing powerful monitoring and management solutions to monitor and observe your apps in real-time.
    sematext_logs(o={}):: self.fn('sematext_logs', o),

    // Sematext is a hosted monitoring platform for metrics based on InfluxDB. Providing powerful monitoring and management solutions to monitor and observe your apps in real-time.
    sematext_metrics(o={}):: self.fn('sematext_metrics', o),

    // The Vector socket sink sends logs to socket receiver.
    socket(o={}):: self.fn('socket', o),

    // The Splunk HTTP Event Collector (HEC) is a fast and efficient way to send data to Splunk Enterprise and Splunk Cloud. Notably, HEC enables you to send data over HTTP (or HTTPS) directly to Splunk Enterprise or Splunk Cloud from your application.
    splunk_hec(o={}):: self.fn('splunk_hec', o),

    // StatsD is a standard and, by extension, a set of tools that can be used to send, collect, and aggregate custom metrics from any application. Originally, StatsD referred to a daemon written by Etsy in Node.
    statsd(o={}):: self.fn('statsd', o),

    // The Vector vector sink sends logs and metrics to Vector source.
    vector(o={}):: self.fn('vector', o),
  },
}
