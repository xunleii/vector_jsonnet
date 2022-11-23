# Modularity

_The goal of this library is to provide a way to easily share pre-made Vector pipelines._

## Module structure

A module object contains 3 elements:

- **in/out components**: theses are the component names of the input and output of the pipelines.
- **vars:** theses variables are used to easily edit the module pipeline, avoiding direct overwriting
- **pipeline:** that is why the module exists

A module must be defined like that:

```jsonnet
// Module description
//
// maintainer: NAME <contact> ... this allows user to known who to contact when he need
//                                information or when a problem occurs

{
  // all imported modules are merged in this object, don't forget the '+'
  modules+:: {
    <module_name>: {
      // input/output components used to easily import this module on our pipelines
      use: { [input_component]: output_component  }
        // module variables
      vars:: {
        c: false
      } +

      // pipeline definition
      vector
      .global({})
      .components({})
      .pipelines([])
    }
  }
}
```

See the [kubernetes module](modules/kubernetes.vector.libsonnet) for an example of an "implementation" of a Vector module
and [vector.toml.jsonnet](vector.toml.jsonnet) to see to use a module.
