{
  transforms:: {
    fn(type, o):: { kind:: 'transforms', type: type } + o,

    // The Vector add_fields transform shapes logs
    add_fields(o={}):: self.fn('add_fields', o),

    // The Vector add_tags transform shapes metrics
    add_tags(o={}):: self.fn('add_tags', o),

    // The Vector ansi_stripper transform sanitizes logs
    ansi_stripper(o={}):: self.fn('ansi_stripper', o),

    // AWS CloudWatch Logs Subscription events allow you to forward AWS CloudWatch Logs to external systems. Through the subscriiption, you can: call a Lambda, send to AWS Kinesis, or send to AWS Kinesis Firehose (which can then be forwarded to many destinations).
    aws_cloudwatch_logs_subscription_parser(o={}):: self.fn('aws_cloudwatch_logs_subscription_parser', o),

    // The Vector aws_ec2_metadata transform enriches logs from AWS EC2 instance metadata.
    aws_ec2_metadata(o={}):: self.fn('aws_ec2_metadata', o),

    // The Vector coercer transform shapes logs
    coercer(o={}):: self.fn('coercer', o),

    // The Vector concat transform shapes logs
    concat(o={}):: self.fn('concat', o),

    // The Vector dedupe transform filters logs
    dedupe(o={}):: self.fn('dedupe', o),

    // The Vector filter transform filters logs
    filter(o={}):: self.fn('filter', o),

    // The Vector geoip transform enriches logs from MaxMind GeoIP2 and GeoLite2 city databases.
    geoip(o={}):: self.fn('geoip', o),

    // The Vector grok_parser transform parses logs
    grok_parser(o={}):: self.fn('grok_parser', o),

    // The Vector json_parser transform parses logs
    json_parser(o={}):: self.fn('json_parser', o),

    // The Vector key_value_parser transform parses logs
    key_value_parser(o={}):: self.fn('key_value_parser', o),

    // The Vector log_to_metric transform converts logs
    log_to_metric(o={}):: self.fn('log_to_metric', o),

    // The Vector logfmt_parser transform parses logs
    logfmt_parser(o={}):: self.fn('logfmt_parser', o),

    // The Vector lua transform programs logs and metrics
    lua(o={}):: self.fn('lua', o),

    // The Vector merge transform reduces logs
    merge(o={}):: self.fn('merge', o),

    // The Vector metric_to_log transform converts metrics
    metric_to_log(o={}):: self.fn('metric_to_log', o),

    // The Vector reduce transform reduces logs
    reduce(o={}):: self.fn('reduce', o),

    // The Vector regex_parser transform parses logs
    regex_parser(o={}):: self.fn('regex_parser', o),

    // The Vector remap transform programs logs
    remap(o={}):: self.fn('remap', o),

    // The Vector remove_fields transform shapes logs
    remove_fields(o={}):: self.fn('remove_fields', o),

    // The Vector remove_tags transform shapes metrics
    remove_tags(o={}):: self.fn('remove_tags', o),

    // The Vector rename_fields transform shapes logs
    rename_fields(o={}):: self.fn('rename_fields', o),

    // The Vector sampler transform filters logs
    sampler(o={}):: self.fn('sampler', o),

    // The Vector split transform shapes logs
    split(o={}):: self.fn('split', o),

    // The Vector swimlanes transform routes logs
    swimlanes(o={}):: self.fn('swimlanes', o),

    // The Vector tag_cardinality_limit transform filters metrics
    tag_cardinality_limit(o={}):: self.fn('tag_cardinality_limit', o),

    // Tokenizes a field's value by splitting on white space, ignoring special wrapping characters, and zip the tokens into ordered field names.
    tokenizer(o={}):: self.fn('tokenizer', o),

    // The Vector wasm transform programs logs
    wasm(o={}):: self.fn('wasm', o),
  },
}
