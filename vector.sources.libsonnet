{
  sources:: {
    source_(type, o):: {kind:: 'sources', type: type} + o,

    file(o):: self.source_('file', o),
  },
}