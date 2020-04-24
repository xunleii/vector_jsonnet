local vector = (import '../../vector.libsonnet').vector;

// STDIO Example
// ------------------------------------------------------------------------------
// A simple STDIN / STDOUT example. This script is used in the getting started
// guide:
//
// https://vector.dev/guides/getting-started
vector
.components({
  'in': vector.sources.stdin(),
  out: vector.sinks.console({ encoding: 'text' }),
})
.pipelines([['in', 'out']])
.json
