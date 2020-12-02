# [vector.dev](vector.dev) jsonnet library

[![Jsonnet](https://img.shields.io/badge/jsonnet-v0.15.0+-blue.svg)](https://github.com/google/jsonnet/releases)
[![GitHub tag (latest SemVer pre-release)](https://img.shields.io/github/v/tag/xunleii/vector_jsonnet?include_prereleases)](https://github.com/xunleii/vector_jsonnet/releases)
[![GitHub Issues](https://img.shields.io/github/issues/xunleii/vector_jsonnet.svg)](https://github.com/xunleii/vector_jsonnet/issues)
[![Contributions welcome](https://img.shields.io/badge/contributions-welcome-orange.svg)](#contributing)
[![License](https://img.shields.io/badge/license-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

***vector_jsonnet*** *provides an alternative way of writing your TOML Vector configurations.*
*Instead, you write list of component and link them through simple pipelines. This enables you to write reusable Vector components
and pipelines that you can reuse or share. It can also be integrated with tools likes [tanka](tanka.dev) in order to deploy vector
instances on Kubernetes, with their TOML configuration, without writing a single TOML file.*

## Getting started

### Prerequisite

**vector_jsonnet** requires Jsonnet.

#### Mac OS X

If you do not have Homebrew installed, [install it now](https://brew.sh/).
Then run:  `brew install jsonnet`

#### Linux

You must build the binary. For details, [see the GitHub
repository](https://github.com/google/jsonnet).

### Install

There is two way to install this library :

#### From git

Fork or clone this repository, using a command such as:
`git clone github.com/xunleii/vector_jsonnet`

#### With [jsonnet-bundler](github.com/jsonnet-bundler/jsonnet-bundler) (recommended)

`jb install https://github.com/xunleii/vector_jsonnet`

## How to use

### Import

After installing this library, add the appropriate import statements for the library to your Jsonnet code:

```jsonnet
// assuming you have installed this lib with jb
local vector = (import "vendor/vector_jsonnet/vector.libsonnet").vector;

{ /* call vector.METHOD */ }
```

> You can also import it by merging it with the root Jsonnet object
>
> ```jsonnet
> (import "vendor/vector_jsonnet/vector.libsonnet") +
> {
>   /* call $.vector.METHOD */
> }
> ```

### Global settings *(vector.global)*

> Global options are relevant to Vector as a whole and apply to global behavior.

Theses options are configurable in this section. However, the `.log_schema` cannot be managed by this library because it
seems to be "invalid" by many TOML reader. Other settings like [TOML input verbosity](#toml-configtoml) can also be managed here.

**Example:**

```jsonnet
// assuming you have installed this lib with jb
local vector = (import "vendor/vector_jsonnet/vector.libsonnet").vector;

vector.global({
  data_dir: '/var/lib/vector'
})
```

Thanks to jsonnet, it also possible to override or disable fields

```jsonnet
// assuming you have installed this lib with jb
local vector = (import "vendor/vector_jsonnet/vector.libsonnet").vector;

vector.global({
  data_dir: '/var/lib/vector'
})
.global({
  data_dir:: '/var/lib/vector' // this field is now disabled
})
.global({
  data_dir::: '/var/tmp/vector' // this field is now enabled and its value has changed
})
```

### Components *(vector.components)*

> "Component" is the generic term we use for [sources](https://vector.dev/docs/about/concepts/#sources),
[transforms](https://vector.dev/docs/about/concepts/#transforms), and [sinks](https://vector.dev/docs/about/concepts/#sinks).
You compose components to create pipelines, allowing you to ingest, transform, and send data.

Components are the main objects of Vector ; sharing them and use them must be as simple as possible. For that, `vector.components`
 is available and take only one parameter, an object containing the component definitions.

A component definition is a pair of key/value: the component name and the Vector definition of the component (the format is almost
the same as the original Vector, but in JSON(NET) intead of TOML).

However, there is two differences:

- `inputs` field **MUST NOT** be defined because it is managed by the next part, `vector.pipelines`
- `type` field **MUST NOT** be defined manually; this is the role of the helpers. Helpers are functions that add required *hidden*
metadata to the component, and are available at `vector.KIND.COMPONENT(definition)` (where `KIND` is one of `sources`, `transforms`
and `sinks`, and `COMPONENT` refers to the Vector component name).

**Example:**

```jsonnet
local vector = (import "vendor/vector_jsonnet/vector.libsonnet").vector;

vector.global({ /* see global settings example */ })
.components({
  // Ingest data by t
## License

  // Tailing one or more files
  apache_logs: vector.sources.file({
    include: ['/var/log/apache2/*.log'],  // supports globbing
    ignore_older: 86400,  // 1 day
  }),

  // Structure and parse the data
  apache_parser: vector.transforms.regex_parser({
    regex: '^(?P<host>[w.]+) - (?P<user>[w]+) (?P<bytes_in>[d]+) [(?P<timestamp>.*)] "(?P<method>[w]+) (?P<path>.*)" (?P<status>[d]+) (?P<bytes_out>[d]+)$',
  }),

  // Sample the data to save on cost
  apache_sampler: vector.transforms.sampler({
    rate: 50,  // only keep 50%
  }),

  // Send structured data to a short-term storage
  es_cluster: vector.sinks.elasticsearch({
    host: 'http://79.12.221.222:9200',  // local or external host
    index: 'vector-%Y-%m-%d',  // daily indices
  }),

  // Send structured data to a cost-effective long-term storage
  s3_archives: vector.sinks.aws_s3({
    region: 'us-east-1',
    bucket: 'my-log-archives',
    key_prefix: 'date=%Y-%m-%d',  // daily partitions, hive friendly format
    compression: 'gzip',  // compress final objects
    encoding: 'ndjson',  // new line delimited JSON
    batch: {
      max_size: 10000000,  // 10mb uncompressed
    },
  }),
})
```

> **NOTE:** The helpers are generated using the
[`vector.spec.toml`](https://github.com/timberio/vector/blob/master/config/vector.spec.toml) file. If a component is not available
in this file or if **vector_jsonnet** is not up to date, you can "generate" a custom component by using
`vector.KIND.fn(COMPONENT, definition)` (where `KIND` is one of `sources`, `transforms` and `sinks`, and `COMPONENT` refers to
the Vector component name).
>
> *Example:* `vector.sources.fn('kubernetes', {})`

### Pipelines *(vector.pipelines)*

> A "pipeline" is the end result of connecting [sources](https://vector.dev/docs/about/concepts/#sources),
[transforms](https://vector.dev/docs/about/concepts/#transforms), and [sinks](https://vector.dev/docs/about/concepts/#sinks).
You can see a full example of a pipeline in the [configuration section](https://vector.dev/docs/setup/configuration/).

A pipeline is, in this library, just a list of the components name defines in the [component section](#components-vectorcomponents).
This describe the *flow* of your events; it generally start with a `source` and end with a `sink`.
As a picture often speaks better than words, here an example how to define pipelines (using component defined above).

**Example:**

```jsonnet
local vector = (import "vendor/vector_jsonnet/vector.libsonnet").vector;

vector.global({ /* see global settings example */ })
.components({ /* see components example */ })
.pipelines([
  ['apache_logs', 'apache_parser', 'apache_sampler', 'es_cluster'],
  ['apache_logs', 'apache_parser', 's3_archives'],
])
```

> **WARN:** be careful when you define several pipelines with the same component; if you change something in the order of the
> component, all pipelines are also changed
>
> ```jsonnet
> .pipelines([
>   ['apache_logs', 'apache_parser', 'apache_sampler', 'es_cluster'],
> ])
> can be visualised like
> 'apache_logs' -> 'apache_parser' -> 'apache_sampler' -> 'es_cluster'
> ```
>
> But
>
> ```jsonnet
> .pipelines([
>   ['apache_logs', 'apache_parser', 'apache_sampler', 'es_cluster'],
>   ['apache_logs', 'apache_sampler', 'apache_parser']
> ])
> can be visualised like
>         /--------------------------------------
>        v                                       \
> 'apache_logs' -> 'apache_parser' -> 'apache_sampler' -> 'es_cluster'
>         \--------------------^
> ```
>
> which creates a loop in the pipeline and this is not handled by this library

### Outputs

When your configuration is ready, you can get the configuration in two format

#### JSON *(CONFIG.json)*

The JSON output is mainly use for testing and debugging purpose, and must not be used to generates configuration for vector.

#### TOML *(CONFIG.toml)*

The TOML output returns a string representing the full TOML configuration file.
The "verbosity" can be configured inside the global settings, through the *hidden* object `toml` :

- `enable_intro: true` adds the [introduction part](https://github.com/xunleii/vector_jsonnet/blob/master/vector.out.toml.libsonnet#L79)
at the head of the file. This `intro` can be override by adding `{assets+:{intro: 'NEW INTRO'}}` to your vector object.
- `enable_headers: true` adds some [comments](https://github.com/xunleii/vector_jsonnet/blob/master/vector.out.toml.libsonnet#L97) to
separates sections into the final TOML. As the first parameter, theses comments can be override by adding
`{assets+:{global: 'GLOBAL SEPARATOR', sources: 'SOURCES SEPARATOR', transforms: 'TRANSFORMS SEPARATOR', sinks: 'SINKS SEPARATOR'}}`
to your vector object.
- `enable_description` adds comments before each components with their `description` hidden fields.
- `enable_multilines` enables to have multi-lines string instead of a single string with `\n` on the final TOML. This features is mainly
used to increase TOML readability for the [LUA component](https://vector.dev/docs/reference/transforms/lua/). But, because the multi-lines
feature implementation is heavy, it is disabled by default.

Examples about theses settings are available in `examples/toml` ;

- `jsonnet -S examples/toml/full.jsonnet` to see TOML with all settings enabled
- `jsonnet -S examples/toml/mini.jsonnet` to see same vector configuration, with all settings disabled

> **WARN**: merging two vector objects erase TOML configuration (this avoid you to import unexpected TOML settings from module)
>
> ```jsonnet
> local vector = (import "vendor/vector_jsonnet/vector.libsonnet").vector;
>
> (
>   vector.global({
>     toml+:: {
>       enable_intro: true // TOML will be displayed with intro
>     },
>     data_dir: '/var/lib/vector'
>   }) +
>   vector.global({
>     data_dir: '/var/lib/vector'
>   })
> )
> .toml // TOML will be displayed without intro
> ```
>

## Modules

See [examples/modular](examples/modular/README.md)

## Contributing

Thanks for taking the time to start contributing!!
Just before, please take a look of [CONTRIBUTING.md](/CONTRIBUTING.md)
