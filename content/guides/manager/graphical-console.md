---
layout: default
title: Graphical Console
section: Brightbox Manager
---

The Graphical Console gives you encrypted access to your Cloud Server
as if you were at at its monitor with a keyboard and mouse plugged in.
This lets you investigate problems even if your OS won't boot or is
inaccessible via the network.

Getting access to the Graphical Console is simple. You just need a
modern web browser with support for HTML5 canvas (e.g: Firefox 3.6+,
Google Chrome, Safari, IE 9+) and web sockets (or instead Flash).

In the Brightbox Manager, click "Cloud Servers" in the sidebar on the
left. There is a button next to each server in the list that brings up
the action menu. Bring up the menu for the server you wish to access and click "Open Console"

![](/images/manager-windows-action-menu-cropped.png)

This will pop-up a window with the graphical console window in it
(make sure your browser allows the window to pop-up).

![](/images/manager-windows-console-loggedin-cropped.png)

Normally, the console works over HTTPS using the usual tcp port 443,
but if your browser is a bit old and has to fall back to Flash, then
it will use tcp port 843 as well.

