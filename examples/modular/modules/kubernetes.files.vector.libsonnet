// This Vector module ingests Kubernetes logs, extracts some metadata like pod or
// container name and generates metrics about the number of ingested events.
//
// NOTE(25/04/2020): This module only exists for demonstration/testing purposes;
//                   currently, the source 'kubernetes' and the tranform
//                   'kubernetes_pod_metadata' are out of documentation (see
//                   https://github.com/timberio/vector/pull/2222) and I
//                   recommend to use them instead of this module
//
// maintainer: Alexandre NICOLAIE <github.com/xunleii>

{
  modules:: {
    kubernetes::
      local kubernetes = $.modules.kubernetes;

      {
        // in and out objects are used to known the endpoints of the current module.
        'in':: {},
        out:: {
          events: 'kubernetes_event_metadata',
          stdout: 'kubernetes_stream.stdout',
          stderr: 'kubernetes_stream.stderr',
          metrics: 'kubernetes_logs_metrics',
        },

        // vars can be used to easily overwrite some values
        // in this modules
        vars:: {
          // ignore logs older than 1 day
          ignore_older: 86400,

          // enable the event field 'node' on each events, but
          // require the environment variable VECTOR_NODE_NAME
          enable_node_field: true,

          // enable to generates some metrics about log ingestion
          enable_metrics: false,

          // defines grok patterns used to extracts metadata from file name and event message
          grok_patterns: {
            filename: '/var/log/pods/%{DATA:kubernetes.namespace}_%{DATA:kubernetes.name}_%{DATA:object_uid}/%{DATA:container_name}/%{GREEDYDATA}',
            event: '%{TIMESTAMP_ISO8601:timestamp} (?<stream>stderr|stdout) (F|P) %{GREEDYDATA:message}',
          },
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
        kubernetes_ingest: $.vector.sources.file({
          description:: |||
            Fetch all pods logs from the host /var/lib/pods directory.
          |||,

          include: ['/var/log/pods/*/*/*.log'],
          ignore_older: kubernetes.vars.ignore_older,
          oldest_first: true,  // force Vector to read older logs before newest

          fingerprinting: {
            strategy: 'checksum',
            ignored_header_bytes: 44,  // ignore the first common pattern on kubernetes logs (TIMESTAMP STREAM F)
            fingerprint_bytes: 256,
          },
        }),

        // Add the Kubernetes node field on each event.
        [if kubernetes.vars.enable_node_field then 'kubernetes_add_node']:
          $.vector.transforms.add_fields({
            description:: |||
              Add the field 'node' to the event, based on the environment 
              variable VECTOR_NODE_NAME.
            |||,

            fields: { 'kubernetes.node_name': '${VECTOR_NODE_NAME}' },
          }),

        // Extract POD and CONTAINER fields from the file name
        kubernetes_pod_metadata: $.vector.transforms.grok_parser({
          description: |||
            Extract 'kubernetes.namespace', 'kubernetes.name', 'object_uid'
            and 'container_name' fields from the event's file name.
          |||,

          field: 'file',
          pattern: kubernetes.vars.grok_patterns.filename,
        }),

        // Parse kubernetes event and extract EVENT metadata (timestamp, stream and message)
        kubernetes_event_metadata: $.vector.transforms.grok_parser({
          description: |||
            Extract 'timestamp', 'stream' and 'message' from the kubernetes 
            event.
          |||,

          field: 'message',
          pattern: kubernetes.vars.grok_patterns.event,
          types: {
            timestamp: 'timestamp|%+',
          },
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
                  [if kubernetes.vars.enable_node_field then 'node']: '{{kubernetes.node_name}}',
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
        if kubernetes.vars.enable_node_field
        then ['kubernetes_ingest', 'kubernetes_add_node', 'kubernetes_pod_metadata', 'kubernetes_event_metadata']
        else ['kubernetes_ingest', 'kubernetes_pod_metadata', 'kubernetes_event_metadata'],

        // Since 'kubernetes_event_metadata' pipeline has already been generated, we
        // can start a new pipeline directly on this component
        ['kubernetes_event_metadata', 'kubernetes_stream.stdout'],
        ['kubernetes_event_metadata', 'kubernetes_stream.stderr'],

        if kubernetes.vars.enable_metrics
        then ['kubernetes_event_metadata', 'kubernetes_logs_metrics'],
      ]),
  },
}
