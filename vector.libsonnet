{
  vector::
    (import 'vector.sources.libsonnet') +
    (import 'vector.transforms.libsonnet') +
    (import 'vector.sinks.libsonnet') +
    {
      config_+: { index: {} },
      // Global options are relevant to Vector as a whole and apply to global behavior. Theses options also
      // configure the JSONNET generation behaviour.
      global(o)::
        self +
        { config_: { enable_headers:: false, enable_descriptions:: false } } +
        { config_+: o },

      // Components allow you to collect, transform, and route data with ease.
      components(o)::
        self +
        {
          config_+:
            std.foldr(
              function(component, config)
                assert 'kind' in o[component] : 'vector.sources, vector.transforms or vector.sinks must be used to generate component';
                assert 'type' in o[component] : 'vector.sources, vector.transforms or vector.sinks must be used to generate component';

                config {
                  index+:: { [component]: o[component].kind },
                  [o[component].kind]+: {
                    [component]: o[component],
                  },
                },
              std.objectFields(o),
              super.config_
            ),
        },


      pipelines(o)::
        self +
        {
          config_+:
            std.foldr(
              function(pipeline, config)
                std.foldr(
                  function(i, config)
                    local component = pipeline[i];
                    local input = pipeline[i - 1];

                    assert component in config.index : "component '%s' not defined" % component;
                    assert input in config.index : "component '%s' not defined" % input;

                    local kind = config.index[component];

                    config {
                      [kind]+: {
                        [component]+: {
                          inputs: [input],
                        },
                      },
                    },
                  std.range(1, std.length(pipeline) - 1),
                  config
                ),
              o,
              super.config_
            ),
        },


      json:: self.config_,
      // toml:: {},
    },
}
