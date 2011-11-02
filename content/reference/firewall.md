---
layout: default
title: Cloud Firewall
section: Reference
---

The Cloud Firewall is a distributed firewall for managing network access to, from and between Cloud Servers.

It's controlled using the [API](/reference/api/), commonly using the [CLI](/reference/cli/).

It is stateful, so you only need to write a rule in one direction - you do not need to worry about the reply packets coming back the other way.

See the [Cloud Firewall guide](/guides/cli/firewall/) for a step by step walkthrough of setting up the Cloud Firewall.

### Firewall Policy

A Firewall Policy represents a list of Firewall Rules and is associated with a Server Group.  Rules are reapplied whenever the policy or group membership changes.

When first created, a Firewall Policy has no rules and has no associated Server Group.

A Firewall Policy can only consist of Firewall Rules that accept traffic, which means a Cloud Server can easily be controlled by multiple Firewall Policies without worrying about the ordering of the rules.  A Cloud Server can have multiple Firewall Policies by being in multiple Server Groups.

### Server Group

A Server Group is a logical grouping of Cloud Servers. Servers can be a member of one or more Server Groups, and can be added to or removed from them at any time.

Server Groups are a useful system in their own right, and will be the building blocks of other Brightbox Cloud features.  See the [Server Groups guide](/guides/cli/server-groups/) for more details.

### Firewall Rules

A Firewall Rule is a set of criteria for matching IP packets crossing the firewall.  Packets can be matched based on source or destination address, protocol and source and destination ports. For protocol icmp, the icmp type can also be matched.

#### Direction

There is no explicit concept of incoming or outgoing rules - the direction of the rule is implied by the address criteria.  So when matching on destination address, the source is considered to be the Server Group (so is an outgoing rule).  When matching on source address, the destination is considered to be the Server Group (so is an incoming rule).

#### Address criteria

Source or destination addresses can be a few different types:

<table>
<tr>
<th>Address criteria</th><th>Description</th>
</tr>
<tr><td><code>any</code></td><td>Any IPv4 or IPv6 address</td></tr>
<tr><td><code>0.0.0.0/0</code></td><td>Any IPv4 address</td></tr>
<tr><td><code>::0/0</code></td><td>Any IPv6 address</td></tr>
<tr><td><code>srv-xxxxx</code></td><td>A specific Cloud Server.</td></tr>
<tr><td><code>grp-xxxxx</code></td><td>All the Cloud Servers in a specific Server Group. The rule is automatically updated whenever the group membership changes</td></tr>
<tr><td><code>192.0.43.10</code></td><td>A specific IPv4 address</td></tr>
<tr><td><code>64.12.89.0/24</code></td><td>An IPv4 address with a network mask</td></tr>
<tr><td><code>2a00:1450:400c:c02::93</code></td><td>A specific IPv6 address</td></tr>
<tr><td><code>2a00:1450::/32</code></td><td>An IPv6 address with a network mask</td></tr>
</table>

Both source and destination addresses cannot be specificed in the same rule - one "side" of the rule is always the Server Group that the Firewall Policy is applied to.

#### Protocol criteria

Protocol can be specified as the strings `tcp`, `udp` or `icmp`, or it can be specified as an 8bit integer.  Not specifying a protocol matches all IP protocols.

#### Port criteria

Ports can only be used with protocols `tcp` and `udp`.  Source and destination ports can be specified in a few different ways:

<table>
<tr>
<th>Port criteria</th><th>Description</th>
</tr>
<tr><td><code>22</code></td><td>A single port</td></tr>
<tr><td><code>80,443</code></td><td>A comma separated list of up to 15 ports</td></tr>
<tr><td><code>6667-7000</code></td><td>A range of ports</td></tr>
</table>

Not specifying a port matches all ports.

#### ICMP criteria

Coming Soon