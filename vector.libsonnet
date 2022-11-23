{
  vector::
    (import 'vector.out.toml.libsonnet') +
    (import 'vector.sources.libsonnet') +
    (import 'vector.sinks.libsonnet') +
    (import 'vector.transforms.libsonnet') +
    {
      object+:: { index+:: {}, sinks+: {}, sources+: {}, transforms+: {} },
      // Global options are relevant to Vector as a whole and apply to global behavior. Theses options also
      // configure the JSONNET generation behaviour.
      global(o)::
        self + { object+: o { index+: {} } },

      // Components allow you to collect, transform, and route data with ease.
      components(o)::
        self +
        {
          object+:
            std.foldl(
              function(config, component)
                assert 'kind' in o[component] : 'vector.sources, vector.transforms or vector.sinks must be used to generate component';
                assert 'type' in o[component] : 'vector.sources, vector.transforms or vector.sinks must be used to generate component';

                config {
                  // index maps all components with the 'kind' (sources, sinks, ...). This map is used during pipeline generation
                  // in order to find the right object in the right kind and update its 'inputs' field.
                  index+::
                    // transforms.route are maneged differently because we need to index the routes and not the component.
                    if o[component].type == 'route'
                    then
                      assert 'route' in o[component] : "route object must be defined in route component '%s'" % component;
                      {
                        [component + '.' + route]: o[component].kind
                        for route in (std.objectFields(o[component].route) + ['_unmatched'])
                      }
                    else { [component]: o[component].kind },

                  [o[component].kind]+: {
                    [component]:
                      (if o[component].kind == 'sources' then {} else { inputs+: [] }) +
                      o[component],
                  },
                },
              std.objectFields(o),
              super.object
            ),
        },

      // A "pipeline" is the end result of connecting sources, transforms, and sinks.
      pipelines(pipelines)::
        self +
        {
          object+:
            // iterate over pipelines in order to link the components together
            std.foldl(
              function(config, raw_pipeline)
                if std.length(raw_pipeline) == 0 then config
                else
                  assert raw_pipeline[0] in config.index : "component '%s' not defined" % raw_pipeline[0];
                  // generate the list of item; if the item is an array (used by the modules), we need to
                  // include them into the pipeline, separated by a null value.
                  local pipeline = std.foldl(
                    function(flatten, item)
                      assert item == null || std.isString(item) || (std.isObject(item) && std.length(item) > 0) : 'a pipeline item must be a string or a "pair" value ({key: value})';
                      flatten + if std.isObject(item) then [std.objectFields(item)[0], null, item[std.objectFields(item)[0]]] else [item],
                    raw_pipeline,
                    [],
                  );

                  // iterate over each pipeline item to link the component to the previous one (called as input)
                  std.foldl(
                    function(config, i)
                      // null is used as separator to avoid linking between two component (used by the modules)
                      if pipeline[i] == null then config
                      else
                        assert pipeline[i] in config.index : "component '%s' not defined" % if pipeline[i] == null then 'null' else pipeline[i];
                        local component = std.split(pipeline[i], '.')[0];
                        local input = pipeline[i - 1];
                        local kind = config.index[pipeline[i]];
                        assert component in config[kind] : "component '%s' (%s) not defined" % [component, kind];
                        assert kind != 'source' : "source '%s' must be the first component in the pipeline {%s} %d" % [component, std.join(' -> ', pipeline)];

                        // null is used as separator to avoid linking between two component (used by the modules)
                        if input == null then config
                        else
                          assert config.index[input] != 'sinks' : "sink '%s' must be the last component in the pipeline {%s}" % [input, std.join(' -> ', pipeline)];

                          config {
                            [kind]+: {
                              [component]+: {
                                [
                                // avoid cycle on the same component
                                if component == input then null
                                // avoid duplication on the inputs field
                                else if std.length(std.find(input, config[kind][component].inputs)) > 0 then null
                                else 'inputs'
                                ]+: [input],
                              },
                            },
                          },
                    std.range(1, std.length(pipeline) - 1),
                    config
                  ),
              [pipeline for pipeline in pipelines if pipeline != null],
              super.object
            ),
        },

      json:: std.prune(self.object),
    },
}
