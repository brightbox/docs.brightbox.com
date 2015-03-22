---
layout: default
title: IPv6 Connectivity for Linux users
tags: ipv6, linux, teredo
---


Rumours of IPv4 address-exhaustion have been regularly announced for the past few years, and despite some uncertainty it seems clear that in the future more users will be accessing the internet via IPv6.

All Brightbox [cloud servers](/docs/reference/cloud-servers/) support native IPv6 connectivity, and can be directly accessed via IPv6 before an IPv4 [Cloud IP](/docs/reference/cloud-ips/) is mapped to them (subject to your defined [firewall policies](/docs/reference/firewall/), of course).  Over the past few years many large sites such as Facebook and Google, have enabled IPv6 access, but the majority of home users cannot access them because their network-providers don't offer IPv6 connectivity as standard.

One of the most common ways of gaining IPv6 access is via [6to4](https://en.wikipedia.org/wiki/6to4). This works beautifully if you have a _static_ IPv4 address, and the [documentation is reasonably simple to understand](http://tldp.org/HOWTO/Linux+IPv6-HOWTO/configuring-ipv6to4-tunnels.html).   But this solution is more complex than it needs to be, it should be possible to _easily_ gain access to the IPv6 internet and that's what the [miredo](http://www.remlab.net/miredo/) software allows.

miredo implements the proposed standard described in [RFC 4380](http://www.ietf.org/rfc/rfc4380.txt), which allows your system to obtain an IPv6 address in a simple fashion, and then access the IPv6-internet with it.

If you're running a Debian/Ubuntu desktop getting started is as simple as :

    # apt-get install miredo

Once you've done that wait a few seconds and you should find that you'll have a new tap device:

    # /sbin/ifconfig
    br0       Link encap:Ethernet  HWaddr 00:1c:25:36:5f:f2
    ...
    ...
    teredo    Link encap:UNSPEC  HWaddr 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00
    ...

Here you can see the `teredo`-device, and it looks like it is up.  To actually test connectivity you can now open your favourite web-browser and pointing it at an IPv6 only address such as [http://ipv6.google.com/](http://ipv6.google.com/).

Further IPv6 test-details are available at [http://test-ipv6.com/](http://test-ipv6.com/).
