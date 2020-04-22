{
  sinks:: {
    sink_(type, o):: {kind:: 'sinks', type: type} + o,

    elasticsearch(o):: self.sink_('elasticsearch', o),
    aws_s3(o):: self.sink_('aws_s3', o),
  },
}