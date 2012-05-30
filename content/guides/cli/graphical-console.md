---
layout: default
title: Graphical Console
section: Guides
---

The Graphical Console gives you encrypted access to your Cloud Server
as if you were at at its monitor with a keyboard and mouse plugged in.
This lets you investigate problems even if your OS won't boot or is
inaccessible via the network.

Getting access to the Graphical Console is simple. You just need our
command line interface, a modern web browser with support for HTML5
canvas (e.g: Firefox 3.6+, Chrome, Safari, IE 9+) and web sockets (or
instead Flash).

Call the `activate_console` command using the `brightbox-servers`
command line tool:

    $ brightbox-servers activate_console srv-su22m
    
    Activating console for server srv-su22m
    
     url                                                             token     expires         
    --------------------------------------------------------------------------------------------
     https://srv-su22m.console.gb1.brightbox.com/?password=oyx338tu  oyx338tu  2012-05-30T23:37
    --------------------------------------------------------------------------------------------

This gives you the url of the Graphical Console session, which you
should open with your web browser. The token is valid for 15 minutes.

![Screenshot of logged in console](/images/console-logged-in.png)

You can reactivate the console at any time - a new token will just be
regenerated.  You can only access the console of Cloud Servers that
are active (i.e: "powered on") and if you're behind a firewall you'll
need to have tcp port 50000 allowed out to our console server.
