---
layout: default
title: Getting Started
section: Brightbox Manager
keywords: help
---

Brightbox Manager is a browser-based graphical user interface for managing Brightbox Cloud resources.

It's accessible at [https://manage.brightbox.com](https://manage.brightbox.com). You'll need to have an active [Brightbox Cloud account](https://manage.brightbox.com/signup) to login.

This guide will take you through building and accessing your first cloud server.

Once you've logged into Brightbox Manager you're presented with the dashboard which gives an overview of your account.

<img src="/images/docs/manage-dashboard.png" alt="" class="doc-border doc-center"/>

### Setting an ssh key

When a new server is built, it will attempt to install your SSH key on boot so you can log into it. If you didn't specify a public SSH key when you first signed up for Brightbox Cloud then you'll need to [set one now](/docs/guides/manager/ssh-keys).

### Building a server

Click <q>Cloud Servers</q> in the sidebar on the left to view the server manager. This is a new account so there aren't any servers yet.

<img src="/images/docs/manage-cloud-servers-cropped.png" alt="" class="doc-center doc-border"/>

Click <q>New Cloud Server</q> to show the dialog box for configuring a new server.

Choose a suitable name for your first server and select whichever [server type](/docs/reference/server-types/) you'd like. Here I've increased it to a <q>Mini</q> which gives us 1GB RAM. The costs of each different server type are available on [the pricing page](/pricing/#cloud_servers).

<img src="/images/docs/manage-new-cloud-server.png" alt="" class="doc-center doc-border"/>

Then switch to the <q>Image</q> tab to choose which [server image](/docs/reference/server-images/) to use; basically you're choosing which operating system to install. I've selected an official 64bit Ubuntu 14.04 image here:

<img src="/images/docs/manage-new-cloud-server-image-cropped.png" alt="" class="doc-center doc-border"/>

Now click <q>Create</q> and your new server will begin building. This usually takes about 30 seconds and the status will update automatically when it's ready, so no need to refresh the page impatiently :)

<img src="/images/docs/manage-cloud-server-list-first-server-cropped.png" alt="" class="doc-center doc-border"/>

As you can see here, we've built one new server and it's been given the identifier `srv-dmw0k`.

#### Your server is now active

At this point your server is active and if you have an IPv6 internet connection [or tunnel](/blog/2014/10/23/getting-ipv6-at-home-with-teredo/), you can connect directly to it with SSH using the IPv6 DNS name. Our official Ubuntu images are pre-installed with a user named `ubuntu`. You can use `sudo` to get `root` access:


    #!shell
    $ ssh -l ubuntu ipv6.srv-dmw0k.gb1.brightbox.com
    The authenticity of host 'ipv6.srv-dmw0k.gb1.brightbox.com (2a02:1348:178:42e9:24:19ff:fee1:ba6)' can't be established.
    ECDSA key fingerprint is f4:a0:2f:61:91:6e:4b:d0:3e:95:c4:ea:75:73:8e:85.
    Are you sure you want to continue connecting (yes/no)? yes
    Warning: Permanently added 'ipv6.srv-dmw0k.gb1.brightbox.com,2a02:1348:178:42e9:24:19ff:fee1:ba6' (ECDSA) to the list of known hosts.
    Welcome to Ubuntu 14.04.1 LTS (GNU/Linux 3.13.0-44-generic x86_64)
    
    ubuntu@srv-dmw0k:~$ uptime
     18:06:26 up 0 min,  1 user,  load average: 0.35, 0.09, 0.03


### Mapping a Cloud IP

To give your server a public IPv4 address, you need to map a [Cloud IP](/docs/reference/cloud-ips/) to it. Cloud IPs are IPv4 addresses that belong to your account and can be moved between cloud servers (and some other resource types too such as [load balancers](/docs/reference/load-balancers/)).

<img src="/images/docs/manage-cloud-server-list-cloud-ip-add.png" alt="" class="doc-center doc-border"/>

<img src="/images/docs/map-cloud-ip-dialog.png" alt="" class="doc-right doc-border"/>

In the server list find the <q>Cloud IPs</q> column and click <q>Add +</q> which brings up the <q>Map Cloud IP</q> dialog box. Select <q>Create & map new Cloud IP</q> from the drop down box and click <q>Map</q>.

<br class="clear"/>

This will create a new Cloud IP for your account and map it onto your new server. The <q>Cloud IPs</q> column will now show a <q>1</q>, to show that 1 cloud ip is mapped to this server. You can hover over it with your mouse to get the details.

<img src="/images/docs/cloud-ip-balloon.png" alt="" class="doc-center doc-border"/>

In this case we've been allocated the IP `109.107.38.214` with the identifier `cip-7vlx0`.

Your server is now accessible by the new Cloud IP, so you can ssh into it:

    #!shell
    $ ssh -l ubuntu 109.107.38.214
    The authenticity of host '109.107.38.214 (109.107.38.214)' can't be established.
    ECDSA key fingerprint is f4:a0:2f:61:91:6e:4b:d0:3e:95:c4:ea:75:73:8e:85.
    Are you sure you want to continue connecting (yes/no)? yes
    Warning: Permanently added '109.107.38.214' (ECDSA) to the list of known hosts.
    Welcome to Ubuntu 14.04.1 LTS (GNU/Linux 3.13.0-44-generic x86_64)
    
    Last login: Fri Jan 30 18:06:24 2015 from 2001:470:1f0a:321:4c15:67a2:da3c:67b9
    ubuntu@srv-dmw0k:~$


For convenience there is a [DNS record](/docs/reference/dns/) that points to the first Cloud IP mapped to a server, in this case `public.srv-dmw0k.gb1.brightbox.com`

    #!shell
    $ host public.srv-dmw0k.gb1.brightbox.com
    public.srv-dmw0k.gb1.brightbox.com has address 109.107.38.214

### Would you like to know more?

Here you used Brightbox Manager to create an Ubuntu server and then mapped a Cloud IP to it.

You might also want to learn more about [accessing cloud servers](/docs/guides/accessing-cloud-servers/) or perhaps [Cloud IPs](/docs/reference/cloud-ips/). There are plenty of [other guides](/docs/guides/) available too.

Or perhaps you'd prefer to use our [command line interface](/docs/guides/cli/getting-started) to manage your Brightbox Cloud resources?
