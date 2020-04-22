local vector = (import '../vector.libsonnet').vector;

vector
.global({ data_dir: '/var/lib/vector' })
.components({
  // Sources specify data sources and are responsible for ingesting data into Vector.
  apache_logs: vector.sources.file({
    include: ['/var/log/apache2/*.log'],  // supports globbing
    ignore_older: 86400,  // 1 day
  }),

  // Transforms parse, structure, and enrich events.
  add_host: vector.transforms.add_fields({
    fields: {
      host: '${HOSTNAME}',
    },
  }),

  // Sinks batch or stream data out of Vector.
  out: vector.sinks.console({
    encoding: 'json',
  }),
})
.pipelines([
  ['apache_logs', 'add_host', 'out'],
])
.json
