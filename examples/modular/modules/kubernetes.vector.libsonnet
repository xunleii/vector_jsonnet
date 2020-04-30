// This Vector module ingests Kubernetes logs, enrich them with some Kubernetes contexts
// and generates metrics about the number of ingested events.
//
// NOTE(25/04/2020): This module only exists for demonstration/testing purposes;
//                   currently, the source 'kubernetes' and the tranform
//                   'kubernetes_pod_metadata' are out of documentation (see
//                   https://github.com/timberio/vector/pull/2222), so I
//                   don't recommend to use it until theses two component
//                   are "officially" available.
//
// maintainer: Alexandre NICOLAIE <github.com/xunleii>

{
  modules:: {
    kubernetes::
      local kubernetes = $.modules.kubernetes;

      {
        // input/output components used to easily import this module on our pipelines
        use: {
          events: 'kubernetes_pod_metadata',
          stdout: 'kubernetes_stream.stdout',
          stderr: 'kubernetes_stream.stderr',
          metrics: 'kubernetes_logs_metrics',
        },

        // vars can be used to easily overwrite some values
        // in this modules
        vars:: {
          include_only: {
            namespaces: [],
            containers: [],
          },

          // enable to generates some metrics about log ingestion
          enable_metrics: false,
        },
      } +

      $.vector
      .global({
        // The directory used for persisting Vector state, such as on-disk buffers, file
        // checkpoints, and more. Because this module is made in order to be used inside
        // a DaemonSet, the /var/log and /var/lib will be mounted with the same host
        // directories.
        // But, because we don't want to store data on hosts, we need to use another
        // path for this purpose.
        //
        // This can be overided by settings data_dir after importing this module
        data_dir: '/var/tmp/vector',
      })
      .components({
        // Fetch all pods logs from the host logs.
        // NOTE: because the source 'kubernetes' is not in the
        //       config/vector.spec.toml file, we need to "import"
        //       it manually.
        kubernetes_ingest: $.vector.sources.fn('kubernetes', {
          description:: |||
            Fetch all Kubernetes pods logs and enrich them with useful 
            Kubernetes context.
          |||,

          include_namespaces: kubernetes.vars.include_only.namespaces,
          include_container_names: kubernetes.vars.include_only.containers,
        }),

        // Enrich Kubernetes logs with Pods metadata.
        // NOTE: because the transform 'kubernetes_pod_metadata' is not
        //       in the config/vector.spec.toml file, we need to "import"
        //       it manually.
        kubernetes_pod_metadata: $.vector.transforms.fn('kubernetes_pod_metadata', {
          description: |||
            Enrich Kubernetes logs with Pods metadata (annotations, labels, ...).
          |||,

          fields: ['name', 'namespace', 'labels', 'annotations', 'node_name'],
        }),

        // Creates swimlanes based on the event stream
        kubernetes_stream: $.vector.transforms.swimlanes({
          description:: |||
            Throw events into two lanes, based on their stream field (stdout or stderr).
          |||,

          lanes: {
            stdout: { 'stream.eq': 'stdout' },
            stderr: { 'stream.eq': 'stderr' },
          },
        }),

        // Generates statistics about logs.
        [if kubernetes.vars.enable_metrics then 'kubernetes_logs_metrics']:
          $.vector.transforms.log_to_metric({
            description:: |||
              Extract the total number of ingested events.
            |||,

            metrics: [
              {
                type: 'counter',
                field: 'message',
                name: 'kubernetes_logs_ingested_total',
                tags: {
                  node: '{{kubernetes.node_name}}',
                  namespace: '{{kubernetes.namespace}}',
                  pod_name: '{{kubernetes.name}}',
                  container_name: '{{container_name}}',
                  stream: '{{stream}}',
                },
              },
            ],
          }),
      })
      .pipelines([
        ['kubernetes_ingest', 'kubernetes_pod_metadata', 'kubernetes_stream.stdout'],
        ['kubernetes_ingest', 'kubernetes_pod_metadata', 'kubernetes_stream.stderr'],

        if kubernetes.vars.enable_metrics
        then ['kubernetes_ingest', 'kubernetes_pod_metadata', 'kubernetes_logs_metrics'],
      ]),
  },
}
