---
layout: default
title: Load Balancers
section: Reference
---

Brightbox Cloud Load Balancers distribute traffic between a pool of your servers, allowing you to scale your systems and have automatic fault tolerance. The balancer runs continuous health checks and removes any unresponsive servers from the pool until they recover.

The Load Balancers are highly available across a Region so can tolerate the loss of an entire Zone without disruption.

Load Balancers are [configurable via our API](https://api.gb1.brightbox.com/1.0/#load_balancer), and therefore also via our CLI tool.  For a step-by-step guide on using the CLI to manage Load Balancers, see the [Load Balancer CLI Guide](/guides/cli/load-balancers/).

### Listeners

Each Load Balancer consists of one or more listeners which control the ports
and protocols it responds to. Each listener has an `in` port, which is
the port it listens on and an `out` port which is the port it uses to connect
to the back end servers.

So, if your back-end servers have a web service running on port `3000` but
you want the load balancer to serve requests on port `80`, you would use a
listener with an `in` port of `80` and an `out` port of `3000`.

#### Protocol

Each listener also has a protocol. There are currently three options for the
listener protocol:

* `tcp`
* `http`
* `http+ws`

If the protocol is set to `tcp`, the load balancer makes a straight 
unmodified tcp connection to the back-end servers.

If the protocol is set to `http` or `http+ws`, the load balancer modifies
the request to add an `X-Forwarded-For` HTTP header so your back-end servers
can see the IP address of the clients.

**Note:** When using the `http` or `http+ws` protocols, there is a `2048` bytes limit
on HTTP headers, 40 bytes of which are used by the `X-Forwarded-For` header.
If you require more than `2008` bytes of headers (very large cookies might
need this), then you should use the `tcp` protocol, which has no such
limitation.

#### Timeout

The timeout setting determines how long a connection may remain open, without any activity, before it is closed.  The timeout is specified in milliseconds and must be between 5,000 and 86,400,000 (one day). By default the timeout is 50,000 milliseconds.

### Health Checks

Each Load Balancer can have one or more health checks.  A health check defines how the Load Balancer detects problems with your back-end servers.  The Load Balancer will not send requests to unhealthy back-end servers until they recover.

#### Port and timings
Each health check has several options. The `port` is the tcp port that the Load Balancer will attempt to connect to on each back-end server. `timeout` is how long in milliseconds the Load Balancer will wait for the connection to complete before deciding the health check failed. `interval` is how long in milliseconds between each health check.

#### Types

The `type` option specifies whether the health check is a standard tcp connect attempt or a more detailed HTTP check.  It can be set to `tcp` or `http`.

When `type` is set to `http`, the `request` option defines the path to be used by the Load Balancer when making the HTTP health check request.

When `type` is set to `tcp`, the `request` option is ignored.


#### Thresholds

There are two "thresholds" associated with each health check which are used to control when back-end servers are considered unhealthy.

`threshold_down` sets the number of consecutive health checks that must fail for the server to be considered unhealthy.  This can help prevent a transient error with one of your servers causing it to immediately be considered unhealthy.

`threshold_up` sets the number of consecutive health checks that must succeed for an unhealthy back-end server to be considered healthy again and ready for new requests.  This can help when a back-end server isn't completely unhealthy and some health checks are succeeding. In this case you usually do not want the server to start receiving requests.

### Balancing Policies

The Load Balancer policy defines how requests are distributed between servers.

#### Round Robin

When the `policy` is set to `round-robin`, the Load Balancer simply passes each new request to each back-end server in turn.  So request 1 goes to server A, request 2 to server B, request 3 to server C and request 4 to server A again.

This policy is best when your requests tend to take about the same amount of time to complete.

#### Least Connections

When the `policy` is set to `least-connections`, the Load Balancer passes each new request to the back-end server with the least number of connections currently open to it.  This policy is good for when the amount of time your requests take to complete varies a lot.

