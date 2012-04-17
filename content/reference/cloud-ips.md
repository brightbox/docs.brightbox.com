---
layout: default
title: Cloud IPs
section: Reference
---

Cloud IP addresses are publicly routed IPv4 addresses that can be
instantly mapped to Cloud Servers and Load Balancers.

Cloud IPs belong to an account and can be mapped to resources on the
same account. They are added to an account by "creating" them and
removed by "destroying".

### Mapping to a Cloud Server

All servers have private IPv4 address in the `10.x.x.x` range,
accessible only from within the Brightbox network.  Once a Cloud IP is
mapped to a server, packets to and from the Cloud IP are translated
using NAT to the server's private IP address.

Outgoing connections from the server to the Internet are translated to
the first Cloud IP mapped to the server.  If no Cloud IP is mapped, a
shared IP address is used.

Incoming and outgoing connections to and from the server's private IP
(such as from other servers on the Brightbox network) are unaffected
by Cloud IP mappings.

Remapping a Cloud IP address will interrupt any established
connections using the address.

### Mapping to a Load Balancer

Cloud IPs can be mapped to Load Balancers, allowing seamless
transition from one server to many.

Load Balancers are inaccessible until a Cloud IP is mapped to
them. Once a Cloud IP is mapped to a load balancer, packets to the
Cloud IP are translated to the Load Balancers. Load Balancers do not
make outgoing connections to the Internet themselves, so no outgoing
translation occurs.

### A note on Cloud Server interfaces

Cloud IPs are actually mapped to an interface on a server. The API
accepts a server identifier as the destination and maps the IP to the
first available interface. (Cloud Servers currently have only one interface,
but in future they'll support more).

Cloud IPs are mapped directly to load balancers as they do not have
interfaces like Cloud Servers.

### DNS

The first Cloud IP mapped to a Cloud Server is accessible using the DNS
record `public.srv-xxxxx.gb1.brightbox.com` (where `srv-xxxxx` is the
server identifier and `gb1` is the region code).

If no Cloud IP is mapped, the record fails to resolve (returning a
`NXDOMAIN`).

#### Reverse DNS

The default reverse DNS of a Cloud IP is currently of the form
`cip-109-107-36-145.gb1.brightbox.com.`.

Custom reverse DNS for Cloud IPs is covered in the [DNS reference](/reference/dns/) and in the [CLI Reverse DNS Guide](/guides/cli/reverse-dns/).

### Port Translation

Port Translation can be used to change the destination port of a tcp
or udp connection coming into a Cloud IP. They can be used to emulate
having multiple IP addresses on a Cloud Server. It's commonly used to
host multiple TLS/SSL sites on the same server.

Port Translation applies only to connections coming into a Cloud IP -
they do not affect outgoing connections from the Cloud Server.

See the [Port Translation guide](/guides/cli/port-translation/) for a
walk through on how to use them.

#### Port Translation and Firewalling

As with Cloud IP mappings, Port Translation acts on traffic before the
[Cloud Firewall](/reference/firewall/). So, for example, if you're
translating port <code>443</code> on a Cloud IP to port
<code>2443</code> on a Cloud Server, your firewall rules would need to
allow port <code>2443</code>.

#### Port Translation and Load Balancers

Cloud IPs with port translations can of course be mapped to
[load balancers](/reference/load-balancers/) too.  You need to specify
your load balancer listeners to use the translated port. So, if you're
translating port <code>443</code> to port <code>2443</code> then your
load balancer needs a listener on port <code>2443</code>.

