{
  local fmt = $._.fmt,

  // TOML generation has its own configuration, allowing it to enable or
  // disable some features.
  config_+:: {
    toml:: {
      // When multiline is disabled, all multiline strings are displayed into
      // an inline string with \n to separate lines.
      // This feature is disabled by defaut because of its heavy implementation.
      enable_multilines: false,
    },
  },

  // Toml generates the vector TOML configuration based on the given components and
  // pipelines.
  toml::
    (if self.config_.enable_intro then self.assets.intro else '') +
    (if self.config_.enable_headers then self.assets.global else '') +

    // General options are generated throught this block. The .log_schema object will
    // not be manage in this library because of its singularity; all TOML parse used
    // generate an error on this element.
    (
      std.foldl(
        function(toml, opt)
          toml +
          fmt.kvpair(opt, self.config_[opt]),
        [
          opt
          for opt in std.objectFields(self.config_)
          if !std.isObject(self.config_[opt])
        ],
        ''
      ) + '\n'
    ) +
    // All others components (sources, transforms and sinks) are generated in this block,
    // following the given order.
    (
      std.foldl(
        function(toml, kind)
          toml +
          (if self.config_.enable_headers then self.assets.divider + self.assets[kind] else '') +
          (
            std.foldl(
              function(toml, component)
                local obj = { description:: '' } + self.config_[kind][component];

                toml +
                (
                  if self.config_.enable_descriptions
                  then
                    self.assets.description +
                    if std.length(obj.description) == 0 then ''
                    else std.foldl(
                      function(desc, line) desc + '# ' + line + '\n',
                      std.split(std.stripChars(obj.description, '\n'), '\n'),
                      ''
                    )
                  else ''
                ) +
                fmt.table([kind, component], obj) +
                '\n',
              std.objectFields(self.config_[kind]),
              ''
            )
          ),

        ['sources', 'transforms', 'sinks'],
        ''
      )
    ),


  // assets contains all pre-made comments used by this library to generates the
  // TOML ouput. There are fully customizable by editing them before calling .toml
  // in the vector object.
  assets:: {
    intro: |||
      #                                    __   __  __
      #                                    \ \ / / / /
      #                                     \ V / / /
      #                                      \_/  \/
      #
      #                                    V E C T O R
      #                             Configuration Definition
      #
      # ------------------------------------------------------------------------------
      # Website: https://vector.dev
      # Docs: https://vector.dev/docs/
      # Community: https://vector.dev/community/
      # ------------------------------------------------------------------------------
      # More info on Vector's configuration can be found at:
      # /docs/setup/configuration/

    |||,
    global: |||
      # ------------------------------------------------------------------------------
      # Global
      # ------------------------------------------------------------------------------
      # Global options are relevant to Vector as a whole and apply to global behavior.

    |||,
    sinks: |||
      # ------------------------------------------------------------------------------
      # Sinks
      # ------------------------------------------------------------------------------
      # Sinks batch or stream data out of Vector.

    |||,
    sources: |||
      # ------------------------------------------------------------------------------
      # Sources
      # ------------------------------------------------------------------------------
      # Sources specify data sources and are responsible for ingesting data into
      # Vector.

    |||,
    transforms: |||
      # ------------------------------------------------------------------------------
      # Transforms
      # ------------------------------------------------------------------------------
      # Transforms parse, structure, and enrich events.

    |||,
    description: |||
      # ------------------------------------------------------------------------------
    |||,
    divider: '\n\n',
    tab: '  ',
  },

  _:: {
    fmt: {
      key(k): if std.length(std.findSubstr('.', k)) > 0 then std.escapeStringJson(k) else k,
      value(v, indent=0):
        if std.isString(v) then
          if !($.config_.toml.enable_multilines) then std.escapeStringJson(v)
          else
            local lines = std.split(v, '\n');

            if std.length(lines) == 0 then ''
            else if std.length(lines) == 1 then std.escapeStringJson(lines[0])
            else
              '"""' +
              std.foldl(
                function(toml, line)
                  toml +
                  std.repeat($.assets.tab, indent) +
                  std.stripChars(std.escapeStringJson(line), '"') + '\n',
                lines,
                '\n'
              ) + std.repeat($.assets.tab, indent) + '"""'
        else '' + v,
      kvpair(k, v, indent=0): std.repeat($.assets.tab, indent) + fmt.key(k) + ' = ' + fmt.value(v, indent) + '\n',
      table(keys, body, indent=0):
        fmt.table_.head(keys, indent) +
        fmt.table_.body(keys, body, indent),
      table_:: {
        head(keys, indent=0):
          std.repeat($.assets.tab, indent) + '[' + std.join('.', keys) + ']\n',
        body(keys, body, indent=0):
          std.foldl(
            function(toml, field)
              toml +
              if std.isObject(body[field]) then fmt.table(keys + [field], body[field], indent + 1)
              else if std.isArray(body[field]) then fmt.array(keys + [field], body[field], indent + 1)
              else fmt.kvpair(field, body[field], indent + 1),
            // the sort here is used to separate all 'k/v' pair with objects and object arrays,
            // which must be generated after all pairs (https://github.com/toml-lang/toml#array-of-tables).
            std.sort(
              std.objectFields(body),
              function(x)
                if std.isArray(body[x]) && std.length(body[x]) > 0 && std.isObject(body[x][0]) then 2
                else if std.isObject(body[x]) then 1
                else 0
            ),
            ''
          ),
      },
      array(keys, arr, indent=0):
        if std.length(arr) == 0 then fmt.kvpair(keys[std.length(keys) - 1], arr, indent)
        else if !std.isObject(arr[0]) then fmt.kvpair(keys[std.length(keys) - 1], arr, indent)
        else
          std.foldl(
            function(toml, obj)
              toml +
              std.repeat($.assets.tab, indent) + '[[' + std.join('.', keys) + ']]\n' +
              fmt.table_.body(keys, obj, indent),
            arr,
            ''
          ),
    },
  },
}
