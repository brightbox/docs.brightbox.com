---
layout: default
title: Load Balancers
section: Reference
---

Brightbox Cloud Load Balancers distribute traffic between a pool of your
servers, allowing you to scale your systems and have automatic fault
tolerance. The balancer runs continuous health checks and removes any
unresponsive servers from the pool until they recover.

The Load Balancers are highly available across a Region so can tolerate
the loss of an entire Zone without disruption.

Load Balancers are
[configurable via our API](https://api.gb1.brightbox.com/1.0/#load_balancer),
and therefore also via our CLI tool and GUI. For a step-by-step guide on using the
CLI to manage Load Balancers, see the
[Load Balancer CLI Guide](/docs/guides/cli/load-balancers/).

## Listeners

Each Load Balancer consists of one or more listeners which control the ports
and protocols it responds to.

Listeners have four attributes:

* `in-port` is the port that the Load Balancer listens on for incoming
  connections
* `out-port` is the port the load balancer will connect to on your back end
  servers - this will usually be the same as `in-port`
* `type` is the protocol the listener should use, can be `http`, `http+ws`, `https`, `https+wss` or `tcp`
* `timeout` is the time (in milliseconds) after which inactive
  connections will be closed. It defaults to 50 seconds if not
  specified.

So, if your back-end servers have a web service running on port `3000` but
you want the load balancer to serve requests on port `80`, you would use a
listener with an `in` port of `80` and an `out` port of `3000`.

### Type

There are currently five options for the listener type.

#### TCP

If the type is set to `tcp`, the load balancer makes a straight
unmodified tcp connection to the back-end servers. Useful for load
balancing non-http services such as SMTP or SSH.

#### HTTP

All the `http` types are HTTP listeners and the load balancer parses
the request and adds a `X-Forwarded-For` header, so your back-end
servers can see the IP address of the client.

The `X-Forwarded-Proto` header is explicitly removed from HTTP requests.

#### SSL and TLS

The `https` type supports secure connections using SSLv3, TLS 1.0, 1.1
and 1.2. All https listeners on a load balancer will use the one same
[x509](https://en.wikipedia.org/wiki/X.509) certificate and private
key, which you need to provide in PEM format. Any
[intermediate certificates](https://en.wikipedia.org/wiki/Intermediate_certificate_authorities)
should go after the main certificate in the certificate PEM file.

The ciphersuite is specified as per [Mozilla's own recommendations](https://wiki.mozilla.org/Security/Server_Side_TLS).

The load balancer adds a `X-Forwarded-Proto: https` header to requests so that backend servers can distinguish them as having been encrypted.

SSLv3 support is disabled by default and must be explicitly enabled. SSLv3 is [no longer considered secure](/blog/2014/10/22/poodle-sslv3-security-vulnerability/) and it is recommended to disable it where possible. If you need to support older browsers and clients that don't speak TLS, then you should enable SSLv3.

#### WebSockets

With `http+ws` and `https+wss` listener types, Load Balancers can accept both
standard HTTP and
[WebSocket](https://en.wikipedia.org/wiki/WebSockets) connections over
the same port. The `timeout` (either default or specified) is applied
to standard HTTP connections and WebSocket connections are given a
fixed timeout of 1 day.

#### Request buffer size

When using the HTTP types, there is a size limit on the HTTP request
headers that can be controlled with the <q>Request buffer size</q> option. The higher this setting, the more memory each connection requires on the load balancer, so the less concurrent connections can be supported.

It's set to 4096 bytes by default which allows 20,000 concurrent connections and should support the majority of use cases.

Some apps need large buffer sizes to handle very large cookies or lots of custom HTTP headers set by a CDN, whereas some don’t use cookies and can set a very low buffer size (a buffer size as low as 1024 bytes will allow up to 80,000 concurrent connections)

Requests that exceed this limit will get a HTTP 400 (Bad
Request) error.

Note that `60` bytes of the buffer are used by the `X-Forwarded-For`
and `X-Forwarded-Proto` headers.


### Timeout

The timeout setting determines how long inactive connections remain
open before they are closed by the load balancer. The timeout is
specified in milliseconds and must be between `5000` and `86400000`
(one day). By default the timeout is `50000` milliseconds (50 seconds).

## Health Checks

Each Load Balancer can have one health check. A health check defines
how the Load Balancer detects problems with your back-end servers. The
Load Balancer will not send requests to unhealthy back-end servers
until they recover.

### Port and timings

The health check has several options. The `port` is the tcp port that the
Load Balancer will attempt to connect to on each back-end server.
`timeout` is how long in milliseconds the Load Balancer will wait for the
connection to complete before deciding the health check failed. `interval`
is how long in milliseconds between each health check.

The health checks are run for each listener, so if you specify a 20
second interval and have 2 listeners you will actually see checks
every 10 seconds on the back end servers.

### Types

The `type` option specifies whether the health check is a standard tcp
connect attempt or a more detailed HTTP check.  It can be set to `tcp`
or `http`.

When `type` is set to `http`, the `request` option defines the path to be
used by the Load Balancer when making the HTTP health check request.

When `type` is set to `tcp`, the `request` option is ignored.

### Thresholds

There are two "thresholds" associated with the health check which are used
to control when back-end servers are considered unhealthy.

`threshold_down` sets the number of consecutive health checks that must
fail for the server to be considered unhealthy.  This can help prevent a
transient error with one of your servers causing it to immediately be
considered unhealthy.

`threshold_up` sets the number of consecutive health checks that must
succeed for an unhealthy back-end server to be considered healthy again
and ready for new requests.  This can help when a back-end server isn't
completely unhealthy and some health checks are succeeding. In this case
you usually do not want the server to start receiving requests.

## Balancing Policies

The Load Balancer policy defines how requests are distributed between servers.

### Round Robin

When the `policy` is set to `round-robin`, the Load Balancer simply passes
each new request to each back-end server in turn. So request 1 goes to
server A, request 2 to server B, request 3 to server C and request 4 to
server A again.

This policy is best when your requests tend to take about the same amount
of time to complete.

### Least Connections

When the `policy` is set to `least-connections`, the Load Balancer passes
each new request to the back-end server with the least number of connections
currently open to it.  This policy is good for when the amount of time your
requests take to complete varies a lot.

