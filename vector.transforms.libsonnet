{
  transforms:: {
    transform_(type, o):: {kind:: 'transforms', type: type} + o,

    regex_parser(o):: self.transform_('regex_parser', o),
    sampler(o):: self.transform_('sampler', o),
    swimlanes(o):: error 'not implemented'
  },
}