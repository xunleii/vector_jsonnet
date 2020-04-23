{
  // Sources specify data sources and are responsible for ingesting data into
  sources:: {
    fn(type, o):: { kind:: 'sources', type: type } + o,
    
    // Ingests data through the Docker engine daemon and outputs `log` events.
    docker(o={}):: self.fn('docker', o),

    // Ingests data through one or more local files and outputs `log` events.
    file(o={}):: self.fn('file', o),

    // Ingests data through an internal data generator and outputs `log` events.
    generator(o={}):: self.fn('generator', o),

    // Ingests data through the HTTP protocol and outputs `log` events.
    http(o={}):: self.fn('http', o),

    // Ingests data through Systemd's Journald utility and outputs `log` events.
    journald(o={}):: self.fn('journald', o),

    // Ingests data through Kafka and outputs `log` events.
    kafka(o={}):: self.fn('kafka', o),

    // Ingests data through the Heroku Logplex HTTP Drain protocol and outputs `log` events.
    logplex(o={}):: self.fn('logplex', o),

    // Ingests data through the Prometheus text exposition format and outputs `metric` events.
    prometheus(o={}):: self.fn('prometheus', o),

    // Ingests data through a socket, such as a TCP, UDP, or UDS socket and outputs `log` events.
    socket(o={}):: self.fn('socket', o),

    // Ingests data through the Splunk HTTP Event Collector protocol and outputs `log` events.
    splunk_hec(o={}):: self.fn('splunk_hec', o),

    // Ingests data through the StatsD UDP protocol and outputs `metric` events.
    statsd(o={}):: self.fn('statsd', o),

    // Ingests data through standard input (STDIN) and outputs `log` events.
    stdin(o={}):: self.fn('stdin', o),

    // Ingests data through the Syslog protocol and outputs `log` events.
    syslog(o={}):: self.fn('syslog', o),

    // Ingests data through another upstream `vector` sink and outputs `log` and `metric` events.
    vector(o={}):: self.fn('vector', o),
  },
}
