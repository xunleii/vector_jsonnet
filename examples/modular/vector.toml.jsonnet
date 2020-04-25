(
  (import '../../vector.libsonnet') +  // this import is required in order to use the imported modules

  // NOTE: Theses two modules can be switched without any needed modification in this file,
  //       thanks to the module fields vars & out
  // (import 'modules/kubernetes.files.vector.libsonnet') +
  (import 'modules/kubernetes.vector.libsonnet') +
  {
    // configure imported modules
    modules+:: {
      kubernetes+:: {
        vars+:: {
          // vars for kubernetes.vector.libsonnet
          include_only+: { namespaces: ['*'] },  // includes all namespaces (all but kube-system by default)
          enable_metrics: true,
        },
      },
    },

    config::
      local kubernetes = $.modules.kubernetes.out;

      $.modules.kubernetes +
      $.vector
      .global({ toml+: { enable_intro: true, enable_headers: true, enable_descriptions: true } })
      .components({
        // Filter all ingress logs
        ingress_filter: $.vector.transforms.filter({
          description:: |||
            Filter all logs coming from ingress containers.
          |||,

          condition: {
            'pod_name.regex': '.*ingress.*',
          },
        }),


        // Send structured data to Loki for searching of recent data
        search: $.vector.sinks.loki({
          description:: |||
            Send all incoming Kubernetes events to Loki.
          |||,

          endpoint: 'http://loki.logs:3100',  // 'loki' service inside the 'logs' namespace
          tenant_id: 'vector',
          healthcheck: true,

          remove_label_fields: true,
          remove_timestamp: true,
          encoding: 'json',

          labels: {
            instance: '${VECTOR_POD_NAME}',  // https://vector.dev/docs/reference/sinks/loki/#decentralized-deployments
            node: '{{kubernetes.node_name}}',
            namespace: '{{kubernetes.namespace}}',
            pod_name: '{{kubernetes.name}}',
            container_name: '{{container_name}}',
            stream: '{{stream}}',
          },
        }),

        // Only archive ingress event on a durable long-term storage
        archives: $.vector.sinks.aws_s3({
          description:: |||
            Archive only ingress events in order to use them to generate statistics or 
            to be compliant with a regional law (for example).
          |||,

          region: 'us-east-1',
          bucket: 'my_log_archives',
          compression: 'gzip',
          encoding: 'ndjson',
          batch: {
            max_size: 10000000,  // 10mb uncompressed
          },
        }),

        // Send metrics event to Prometheus
        prometheus: $.vector.sinks.prometheus({
          description:: |||
            Send all generated metric events to Prometheus.
          |||,

          address: '0.0.0.0:9598',
          namespace: 'vector',
        }),
      })
      .pipelines([
        [kubernetes.events, 'search'],
        [kubernetes.stdout, 'ingress_filter', 'archives'],
        [kubernetes.metrics, 'prometheus'],
      ]),
  }
).config.toml
