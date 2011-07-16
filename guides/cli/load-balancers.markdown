---
layout: default
title: Load Balancers
---

Load Balancers distribute traffic between a pool of your servers,
allowing you to scale your systems and have automatic fault
tolerance. The balancer runs continuous health checks and removes any
unresponsive servers from the pool until they recover.

Load Balancers are of course completely configurable via our API, and
therefore also via our CLI tool.

This guide will show you how to create a new Load Balancer, add some
servers and test it out.


### Creating a new balancer

You manage Load Balancers using the `brightbox-lbs` command. We're
going to create a new balancer called `test` that will balance between
two servers. It balances tcp port `80` by default, so we don't need
any other options:

    $ brightbox-lbs create -n "test" srv-hrmmb srv-h4lxv
    Creating a new load balancer
    
     id         status    created_on  cloud_ips  nodes                 name
    ------------------------------------------------------------------------
     lba-c76a7  creating  2011-01-25             srv-hrmmb, srv-h4lxv  test
    ------------------------------------------------------------------------

If we view the details of this new balancer, we can see that it is
listening on port `80` and port `443` by default and is health
checking port `80` with a http request. If three http requests to the
backend servers fails in a row then the server will be taken out of
the pool until it recovers:

    $ brightbox-lbs show lba-c76a7
             id: lba-c76a7
         status: active
           name: test
     created_at: 2011-01-25T17:48:20Z
     deleted_at: 
         policy: least-connections
      cloud_ips: 
          nodes: srv-hrmmb, srv-h4lxv
      listeners: 80:80:http,443:443:tcp
    healthcheck: {"threshold_down"=>3, "port"=>80, "timeout"=>5000, "type"=>"http", "request"=>"/", "interval"=>5000, "threshold_up"=>3}

### Mapping a Cloud IP to a Load Balancer

Once the balancer is created, we now map a Cloud IP to make it
available on the internet:

    $ brightbox-cloudips map cip-tqg43 lba-c76a7
    Mapping cip-tqg43 to load balancer lba-c76a7
    
     id         status  public_ip       destination  reverse_dns                         
    --------------------------------------------------------------------------------------
     cip-tqg43  mapped  109.107.35.157  lba-c76a7    cip-109-107-35-157.gb1.brightbox.com
    --------------------------------------------------------------------------------------

### Cloud Balancing in action

Now that our balancer has an IP, we can use curl to see it in action:

    $ curl 109.107.35.157
    I am server srv-hrmmb
    
    $ curl 109.107.35.157
    I am server srv-h4lxv
    
    $ curl 109.107.35.157
    I am server srv-hrmmb
    
    $ curl 109.107.35.157
    I am server srv-h4lxv

### Listeners

Load Balancers listen on port `80` in http mode and port `443` in tcp
mode by default. HTTP requests get a `X-Forwarded-For` header added as
they pass through the balancer, so your web servers can find the
user's IP address. TCP mode doesn't modify the request at all, so it
can be used for SSL and other types of connections (like MySQL or
SMTP).

You can specify your own listeners in the format
`in-port:out-port:type`. `in-port` is the port that the load balancer
listens on and `type` is the mode, currently `http` or
`tcp`. `out-port` is the port the load balancer will connect to on
your back end servers - usually this will be the same as
`in-port`. You can comma separate multiple listeners.

For example, if you want to change your balancer to handle your mail
servers you could change the listeners for IMAP and SSL IMAP:

    $ brightbox-lbs update -l 143:143:tcp,993:993:tcp lba-c76a7

If you want your site available on multiple ports `80`, `90` and `100`,
you'd use:

    $ brightbox-lbs update -l 80:80:http,90:80:http,100:80:http lba-c76a7

All these options can be set at creation time too.


### Health Checks

By default, the cli will set up a health check based on your first
listener. So if your first listener tcp port `25` (SMTP), then the
health check will be a tcp connect to port `25` on your back end
servers.

If your first listener is a http listener than the health check will
be a HTTP request expecting a `HTTP 200` response.

You can, of course, specify your own health checks.

To make a http health check request for `/status.html` on your back
end servers:

    $ brightbox-lbs update --hc-type http --hc-port 80 --hc-request "/status.html" lba-c76a7

To make a tcp connect check on port `22`:

    $ brightbox-lbs update --hc-type tcp --hc-port 22 lba-c76a7

The options `--hc-down` and `--hc-up` set how many consecutive health
checks need to fail or succeed for the back end server to be
considered down, or up.

The option `--hc-timeout` specifies how long the balancer will wait
for a successful response to a health check. If your back end server
doesn't respond in this time then the health check is considered a
failure.

All these options can be set at creation time too.
