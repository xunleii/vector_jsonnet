local vector = (import '../../vector.libsonnet').vector;

// Environment Variables Example
// ------------------------------------------------------------------------------
// A simple example that demonstrates Vector's environment variable
// interpolation syntax. More information can be found in the Environment
// Variables section in our docs:
//
// https://vector.dev/docs/setup/configuration#environment-variables
vector
.global({ data_dir: '/var/lib/vector' })
.components({
  // Ingests Apache 2 log data by tailing one or more log files
  // Example: 194.221.90.140 - - [22/06/2019:11:55:14 -0400] "PUT /integrate" 100 2213
  // Docs: https://vector.dev/docs/reference/sources/file
  apache_logs: vector.sources.file({
    include: ['/var/log/apache2/*.log'],  // supports globbing
    ignore_older: 86400,  // 1 day
  }),

  // Add a field based on the value of the HOSTNAME env var
  // Docs: https://vector.dev/docs/reference/transforms/add_fields
  add_host: vector.transforms.add_fields({
    fields: {
      host: '${HOSTNAME}',
    },
  }),

  // Print the data to STDOUT for inspection
  // Docs: https://vector.dev/docs/reference/sinks/console
  out: vector.sinks.console({
    encoding: 'json',
  }),
})
.pipelines([
  ['apache_logs', 'add_host', 'out'],
])
.json
