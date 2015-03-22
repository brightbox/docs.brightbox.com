---
layout: default
title: IPv6 Connectivity for Mac OS X
tags: ipv6, macosx, teredo
---

Rumours of IPv4 address-exhaustion have been regularly announced for the past few years, and despite some uncertainty it seems clear that in the future more users will be accessing the internet via IPv6.

All Brightbox [cloud servers](/docs/reference/cloud-servers/) support native IPv6 connectivity, and can be directly accessed via IPv6 before an IPv4 [Cloud IP](/docs/reference/cloud-ips/) is mapped to them (subject to your defined [firewall policies](/docs/reference/firewall/), of course).  Over the past few years many large sites such as Facebook and Google, have enabled IPv6 access, but the majority of home users cannot access them because their network-providers don't offer IPv6 connectivity as standard.

By default Mac OS X will enable IPv6 automatically, but you'll almost certainly find that you have no external IPv6 connectivity, instead you have the ability to use IPv6 within your home network.

To get real IPv6 access, such that you can browse to websites on the internet which are only accessible over IPv6 you will need to configure a tunnel, which will let you route over the public network.

The simplest way to proceed is to create an account on a tunnel-broker:


* Create an account at [http://tunnelbroker.net/](http://tunnelbroker.net/).
* Once registered sign-in and "Create Regular Tunnel".
     * This will require you to enter your public IPv4 address, but it will show you the IP you're using so you can copy/paste that.

Once you've done that you can click on the "Example Configuration" tab, select "Mac OS X" as your operating system and you'll be presented a short snippet of text.  The text will look something like this:

    #!/bin/sh
    ifconfig gif0 create
    ifconfig gif0 tunnel 2.126.32.123 216.66.86.114
    ifconfig gif0 inet6 2001:470:6c:a89::2 2001:470:6c:a89::1 prefixlen 128
    route -n add -inet6 default 2001:470:6c:a89::1

Save this to a script such as `~/tunnel.sh`, then launch it via `sudo`:

    sudo ~/tunnel.sh

Once you've done that you should find that you have external connectivity and you can test it by visiting an IPv6-only website such as [http://ipv6.google.com/](http://ipv6.google.com/).
