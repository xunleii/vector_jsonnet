local vector = (import '../../vector.libsonnet').vector;

vector
.components({
  'in': vector.sources.stdin(),
  out: vector.sinks.console({ encoding: 'text' }),
})
.pipelines([['in', 'out']])
.json
