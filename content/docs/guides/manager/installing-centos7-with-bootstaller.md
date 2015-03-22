---
layout: default
title: Installing CentOS 7.0 with Bootstaller
section: Brightbox Manager
keywords: centos, bootstaller
---

Brightbox provides standard images for Windows and several Linux distributions. That's great if you want to get going quickly or have systems that are designed to work on standard images.

But sometimes you need to build something bespoke and that can be a bit fiddly on a cloud.

To solve this problem, we put together the Brightbox Bootstaller. Bootstaller allows you to launch the standard installer for CentOS, Debian, Fedora and Scientific Linux and configure the server just as you like it.

This guide will go through using Bootstaller to install [CentOS 7.0](https://www.centos.org/). First things first, get signed up and logged into [Brightbox Manager](http://manage.brightbox.com/).

### Create the server

Click <q>Cloud Servers</q> in the navigation bar on the left and then click the <q>New Cloud Server</q> button on the right.

This pops up the <q>New Cloud Server</q> dialog.

<img src="/images/docs/centos7-new-server.png" alt="" class="doc-border doc-center"/> 

Give your new server a descriptive name like <q>Centos 7</q> and change the Server Type to whatever you require - I'm going to use a 2GB RAM Small.

Now click the <q>Image</q> tab and search for <q>"bootstaller"</q> to find our official bootstaller images - choose 32bit or 64bit as you require.

<img src="/images/docs/centos7-bootstaller-image.png" alt="" class="doc-border doc-center"/> 


<p class="clearfix"/>

### Open the graphical console

<img src="/images/docs/centos7-open-console.png" alt="" class="doc-border doc-right"/> 

Once the server goes into <q>active</q> state, indicated by the green circle, we want to open the graphical console. Click the server's action menu (signified by a little cog) and click <q>Open Console</q>.

This will popup a new window (make sure your browser doesn't block it) and give you access to the server, as if you were sat at the keyboard and screen.

And it should have booted into the Bootstaller menu, where you can select which operating system you want to start the installer for.

<p class="clearfix"/>

### Installing CentOS 7

<img src="/images/bootstaller-screenshot.png" alt="" class="doc-border doc-center"/>

If you want to get up and running quickly and don't have any custom requirements then select <q>CentOS Kickstart</q> which will run an automated installation that shouldn't require you to make many decisions.

If you want finer control of your installation, such as the exact partition setup or package selection, select the standard <q>CentOS</q> install option.

Whichever you choose, the CentOS network installation process will begin - it will look pretty much just as if you were installing from the CD/DVD.

<img src="/images/docs/centos7-installer-1.png" alt="" class="doc-border doc-center"/>

<img src="/images/docs/centos7-remove-partition.png" alt="" class="doc-border doc-right"/> 

If you choose the non-kickstart installation, then be sure to configure partitioning manually and remove the bootstaller partition (which will be something like 1.98 MB) as it's not needed after install.

<p class="clearfix"/>

### Cloud IPs

Once installation is complete, you can map a Cloud IP to the server (if you don't have IPv6) and ssh right in using the root password you chose during installation!

    ssh root@public.srv-xxxxx.gb1.brightbox.com





