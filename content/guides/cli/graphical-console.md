---
layout: default
title: Graphical Console
section: Guides
---

The Graphical Console gives you encrypted access to your Cloud Server as if you were at at its monitor with a keyboard and mouse plugged in.  This lets you investigate problems even if your OS won't boot or is inaccesible via the network.

Getting access to the Graphical Console is simple. You just need our command line interface, a modern web browser with support for HTML5 canvas (e.g: Firefox 3.6+, Chrome, Safari, IE 9+) and web sockets (or instead Flash).

Call the `activate_console` command using the `brightbox-servers` command line tool:

    $ brightbox-servers activate_console srv-su22m

    Activating console for server srv-su22m
    
     url                                          token     expires             
    -----------------------------------------------------------------------------
     https://srv-su22m.console.gb1.brightbox.com  Aof3Zm59  2011-10-13T18:44:50Z
    -----------------------------------------------------------------------------

This gives you the url of the Graphical Console, which you should open with your web browser. It also provides a security token which is valid for 15 minutes.

Enter the token in the form in your browser and click Login:

![Screenshot of console without a token](/images/console-no-token.png)

Then you'll be granted access to the console:

![Screenshot of logged in console](/images/console-logged-in.png)

You can reactivate the console at any time - a new token will just be regenerated.  You can only access the console of Cloud Servers that are active (i.e: "powered on").