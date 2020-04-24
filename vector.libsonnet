{
  vector::
    (import 'vector.out.toml.libsonnet') +
    (import 'vector.sources.libsonnet') +
    (import 'vector.sinks.libsonnet') +
    (import 'vector.transforms.libsonnet') +
    {
      config_+:: { 
        enable_intro:: false, enable_headers:: false, enable_descriptions:: false,
        index+: {}, sinks+: {}, sources+: {}, transforms+: {} 
      },
      // Global options are relevant to Vector as a whole and apply to global behavior. Theses options also
      // configure the JSONNET generation behaviour.
      global(o)::
        self +        { config_+: o },

      // Components allow you to collect, transform, and route data with ease.
      components(o)::
        self +
        {
          config_+:
            std.foldl(
              function(config, component)
                assert 'kind' in o[component] : 'vector.sources, vector.transforms or vector.sinks must be used to generate component';
                assert 'type' in o[component] : 'vector.sources, vector.transforms or vector.sinks must be used to generate component';

                config {
                  // index maps all components with the 'kind' (sources, sinks, ...). This map is used during pipeline generation
                  // in order to find the right objet in the right kind and update its 'inputs' field.
                  index+::
                    // transforms.swimlanes are maneged differently because we need to index the lanes and not the component.
                    if o[component].type == 'swimlanes'
                    then
                      assert 'lanes' in o[component] : "lanes must be defined in swimlanes component '%s'" % component;
                      {
                        [component + '.' + lane]: o[component].kind
                        for lane in std.objectFields(o[component].lanes)
                      }
                    else { [component]: o[component].kind },

                  [o[component].kind]+: {
                    [component]:
                      (if o[component].kind == 'sources' then {} else { inputs+: [] }) +
                      o[component],
                  },
                },
              std.objectFields(o),
              super.config_
            ),
        },

      // Pipelines allow you describe the data workflow with ease. The data workflow is the list
      // of successive components in which your data are collected, transformed and routed to the
      // final destination.
      pipelines(pipelines)::
        self +
        {
          config_+:
            std.foldl(
              function(config, pipeline)
                if std.length(pipeline) == 0 then config
                else
                  assert pipeline[0] in config.index : "component '%s' not defined" % pipeline[0];
                  std.foldl(
                    function(config, i)
                      assert pipeline[i] in config.index : "component '%s' not defined" % pipeline[i];
                      local component = std.split(pipeline[i], '.')[0];
                      local input = pipeline[i - 1];
                      local kind = config.index[pipeline[i]];
                      assert component in config[kind] : "component '%s' (%s) not defined" % [component, kind];
                      assert kind != 'source' : "source '%s' must be the first component in the pipeline {%s} %d" % [component, std.join(' -> ', pipeline)];
                      assert config.index[input] != 'sinks' : "sink '%s' must be the last component in the pipeline {%s}" % [input, std.join(' -> ', pipeline)];

                      config {
                        [kind]+: {
                          [component]+: {
                            [
                            // avoid duplication on the inputs field
                            if std.length(std.find(input, config[kind][component].inputs)) > 0 then null
                            else 'inputs'
                            ]+: [input],
                          },
                        },
                      },
                    std.range(1, std.length(pipeline) - 1),
                    config
                  ),
              [
                pipeline
                for pipeline in pipelines
                if pipeline != null
              ],
              super.config_
            ),
        },


      json:: std.prune(self.config_),
    },
}
