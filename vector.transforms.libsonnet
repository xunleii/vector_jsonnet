{
  transforms:: {
    fn(type, o):: { kind:: 'transforms', type: type } + o,

    // Modify your observability data as it passes through your topology using Vector Remap Language (VRL)
    remap(o={}):: self.fn('remap', o),

    // Aggregate metrics passing through a topology
    aggregate(o={}):: self.fn('aggregate', o),

    // Parse metadata emitted by AWS EC2 instances
    aws_ec2_metadata(o={}):: self.fn('aws_ec2_metadata', o),

    // Deduplicate logs passing through a topology
    dedupe(o={}):: self.fn('dedupe', o),

    // Filter events based on a set of conditions
    filter(o={}):: self.fn('filter', o),

    // Enrich events with GeoIP metadata
    geoip(o={}):: self.fn('geoip', o),

    // Convert log events to metric events
    log_to_metric(o={}):: self.fn('log_to_metric', o),

    // Modify event data using the Lua programming language
    lua(o={}):: self.fn('lua', o),

    // Convert metric events to log events
    metric_to_log(o={}):: self.fn('metric_to_log', o),

    // Collapse multiple log events into a single event based on a set of conditions and merge strategies
    reduce(o={}):: self.fn('reduce', o),

    // Split a stream of events into multiple sub-streams based on user-supplied conditions
    route(o={}):: self.fn('route', o),

    // Sample events from an event stream based on supplied criteria and at a configurable rate
    sample(o={}):: self.fn('sample', o),

    // Limit the cardinality of tags on metrics events as a safeguard against cardinality explosion
    tag_cardinality_limit(o={}):: self.fn('tag_cardinality_limit', o),

    // Rate limit logs passing through a topology
    throttle(o={}):: self.fn('throttle', o),
  },
}
