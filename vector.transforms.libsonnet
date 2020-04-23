{
  // Transforms parse, structure, and enrich events.
  transforms:: {
    fn(type, o):: { kind:: 'transforms', type: type } + o,
    
    // Accepts and outputs `log` events, allowing you to add one or more log fields.
    add_fields(o={}):: self.fn('add_fields', o),

    // Accepts and outputs `metric` events, allowing you to add one or more metric tags.
    add_tags(o={}):: self.fn('add_tags', o),

    // Accepts and outputs `log` events, allowing you to strips ANSI escape sequences from the specified field.
    ansi_stripper(o={}):: self.fn('ansi_stripper', o),

    // Accepts and outputs `log` events, allowing you to enrich logs with AWS EC2 instance metadata.
    aws_ec2_metadata(o={}):: self.fn('aws_ec2_metadata', o),

    // Accepts and outputs `log` events, allowing you to coerce log fields into fixed types.
    coercer(o={}):: self.fn('coercer', o),

    // Accepts and outputs `log` events, allowing you to concat (substrings) of other fields to a new one.
    concat(o={}):: self.fn('concat', o),

    // Accepts and outputs `log` events, allowing you to prevent duplicate Events from being outputted by using an LRU cache.
    dedupe(o={}):: self.fn('dedupe', o),

    // Accepts and outputs `log` and `metric` events, allowing you to select events based on a set of logical conditions.
    filter(o={}):: self.fn('filter', o),

    // Accepts and outputs `log` events, allowing you to enrich events with geolocation data from the MaxMind GeoIP2 and GeoLite2 city databases.
    geoip(o={}):: self.fn('geoip', o),

    // Accepts and outputs `log` events, allowing you to parse a log field value with Grok.
    grok_parser(o={}):: self.fn('grok_parser', o),

    // Accepts and outputs `log` events, allowing you to parse a log field value as JSON.
    json_parser(o={}):: self.fn('json_parser', o),

    // Accepts `log` events, but outputs `metric` events, allowing you to convert logs into one or more metrics.
    log_to_metric(o={}):: self.fn('log_to_metric', o),

    // Accepts and outputs `log` events, allowing you to parse a log field's value in the logfmt format.
    logfmt_parser(o={}):: self.fn('logfmt_parser', o),

    // Accepts and outputs `log` and `metric` events, allowing you to transform events with a full embedded Lua engine.
    lua(o={}):: self.fn('lua', o),

    // Accepts and outputs `log` events, allowing you to merge partial log events into a single event.
    merge(o={}):: self.fn('merge', o),

    // Accepts and outputs `log` events, allowing you to parse a log field's value with a Regular Expression.
    regex_parser(o={}):: self.fn('regex_parser', o),

    // Accepts and outputs `log` events, allowing you to remove one or more log fields.
    remove_fields(o={}):: self.fn('remove_fields', o),

    // Accepts and outputs `metric` events, allowing you to remove one or more metric tags.
    remove_tags(o={}):: self.fn('remove_tags', o),

    // Accepts and outputs `log` events, allowing you to rename one or more log fields.
    rename_fields(o={}):: self.fn('rename_fields', o),

    // Accepts and outputs `log` events, allowing you to sample events with a configurable rate.
    sampler(o={}):: self.fn('sampler', o),

    // Accepts and outputs `log` events, allowing you to split a field's value on a _literal_ separator and zip the tokens into ordered field names.
    split(o={}):: self.fn('split', o),

    // Accepts and outputs `log` events, allowing you to route events across parallel streams using logical filters.
    swimlanes(o={}):: self.fn('swimlanes', o),

    // Accepts and outputs `metric` events, allowing you to limit the cardinality of metric tags to prevent downstream disruption of metrics services.
    tag_cardinality_limit(o={}):: self.fn('tag_cardinality_limit', o),

    // Accepts and outputs `log` events, allowing you to tokenize a field's value by splitting on white space, ignoring special wrapping characters, and zip the tokens into ordered field names.
    tokenizer(o={}):: self.fn('tokenizer', o),
  },
}
