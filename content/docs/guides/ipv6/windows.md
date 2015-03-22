---
layout: default
title: IPv6 Connectivity for Microsoft Windows Hosts
tags: ipv6, windows, teredo
---


Rumours of IPv4 address-exhaustion have been regularly announced for the past few years, and despite some uncertainty it seems clear that in the future more users will be accessing the internet via IPv6.

All Brightbox [cloud servers](/docs/reference/cloud-servers/) support native IPv6 connectivity, and can be directly accessed via IPv6 before an IPv4 [Cloud IP](/docs/reference/cloud-ips/) is mapped to them (subject to your defined [firewall policies](/docs/reference/firewall/), of course).  Over the past few years many large sites such as Facebook and Google, have enabled IPv6 access, but the majority of home users cannot access them because their network-providers don't offer IPv6 connectivity as standard.

Teredo is a simple protocol which allows devices to automatically configure an IPv6 address, negotiating correctly from behind home-routers and allowing IPv6 connectivity.

The configuration of Teredo will depend upon precisely which release of Windows you're running.


### Windows XP SP 2

Unfortunately Teredo in Windows XP does not support "Hide NAT" which is what your home router probably performs.

You can still experiment by connecting to the Internet directly, without a home router in between, but that is not something that could be recommended for serious use.  It might be that you'll find access works even behind a NAT device, but the odds are not so good.

Add the IPv6 protocol to your interface, via the "Network Connections" option in your Control Panel.  Right-Click “Properties” on your LAN or WiFi connection, then choose:

* "Install...",
* "Protocol",
* "Add..",
* "Microsoft TCP/IP version 6".

Open a command-prompt and run "`ipconfig /all`" and you should now see a link-local IPv6 address, which will look something like this:

    fe80::214:85ff:fe2f:8f06%4

The link-local address won't be useful for connecting to anything, but it will show that IPv6 is now installed and available.

The next step is to configure the Teredo configuration, and to do that you need to run:

    netsh interface ipv6 set teredo client teredo.ipv6.microsoft.com

If you are on a Windows domain, rather than a home workgroup, Teredo will remain disabled even after you configure it, to enable it you'll need to run:

    netsh interface ipv6 set teredo enterpriseclient

Finally you can view the configured Teredo parameters via:

    netsh int ipv6 show teredo

If you see the message "Error : client behind symmetric NAT" then you'll know you're behind a Hide-NAT device and your connectivity will be broken, otherwise you can test your connection by opening a browser to visit the  http://ipv6.google.com/, or some other IPv6-only site.

Bear in mind that Windows XP will always prefer IPv4 over IPv6 when Teredo is used for IPv6 connectivity.  Unless a host has no IPv4 address, its IPv6 address will not be used.



### Windows Vista


IPv6 and Teredo both are enabled by default in Windows Vista.  Teredo also supports Hide-NAT, meaning that things should work even behind an average home-router.  However DNS has been configured so that the system will never resolve any name to an IPv6 address, as long as the system only has link-local and Teredo IPv6 addresses, so we need to trick Vista into allowing DNS lookups to succeed.

The simplest way is to add _another_ IPv6 address to the system, it doesn’t matter which address we configure, since it won’t ever be used anyway.   Open up the "Properties" of your LAN or WiFi interface, and change it to have a static IPv6 address.  Use the 192.168.1.2 equivalent of `2002:c0a8:102::` with a netmask of `48`. Do not configure a default gateway for this address.

Vista would now resolve names to IPv6 addresses, but we need to force it to route traffic through our Teredo interface first. For this, you’ll need to run a Command prompt as "Administrator".

Figure out the ID of your “Teredo Tunneling Pseudo-Interface” by running “`route print`” and looking at the “Interface List” at the top of its output. In my case, it is “`14`″. Then, using this ID, add a default route that forces all IPv6 traffic through Teredo:

     netsh interface ipv6 add route ::/0 interface=14

You can now test your IPv6-connectivity by opening your favourite browser and pointing it at an IPv6 only address such as [http://ipv6.google.com/](http://ipv6.google.com/).

Do remember though that Windows Vista will always prefer IPv4 over IPv6 when Teredo is used for IPv6 connectivity.   Unless a host has no IPv4 address, its IPv6 address will never be used - you can see this when you visit the test site [http://test-ipv6.com/](http://test-ipv6.com/).




### Windows 7

The handling of Windows 7 is exactly the same as that for Windows Vista, with the caveat that Windows 7 will sometimes disable the default IPv6 route when there was is no IPV6 traffic.

To resolve this issue you must configure the Teredo interface to be "Default Qualified", which will prevent it from entering the "Dormant" state, and becoming disabled.
