{
  vector::
    (import 'vector.sources.libsonnet') +
    (import 'vector.transforms.libsonnet') +
    (import 'vector.sinks.libsonnet') +
    {
      config_+:: { index+: {}, sinks+: {}, sources+: {}, transforms+: {} },
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
                  index+::
                    if o[component].type == 'swimlanes'
                    then
                      assert 'lanes' in o[component] : "lanes must be defined in swimlanes component '%s'" % component;
                      {
                        [component + '.' + lane]: o[component].kind
                        for lane in std.objectFields(o[component].lanes)
                      }
                    else { [component]: o[component].kind },

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
                if std.length(pipeline) == 0 then config
                else
                  assert pipeline[0] in config.index : "component '%s' not defined" % pipeline[0];
                  std.foldr(
                    function(i, config)
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
                            if 'inputs' in config[kind][component] && std.length(std.find(input, config[kind][component].inputs)) > 0 then null
                            else 'inputs'
                            ]+: [input],
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
