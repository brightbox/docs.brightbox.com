---
layout: default
title: Getting Started
section: Brightbox Manager
---

The Brightbox Manager is a browser based graphical user interface for managing Brightbox Cloud resources.

It's accessible at [https://manage.brightbox.com](https://manage.brightbox.com). You'll need to have [signed up](https://manage.brightbox.com/signup) for an account.

This guide will take you through building and accessing your first cloud server.

Once logged in, you're presented with the dashboard which gives an overview of your account.

![](/images/manage-dashboard.png)

### Setting an ssh key

When a new server is built, it will attempt to install your ssh key on boot so you can log into it. If you didn't specify a public ssh key when you first signed up for Brightbox Cloud then you'll need to [set one now](/guides/manager/ssh-keys).

### Building a server

Click "Cloud Servers" in the sidebar on the left to view the server manager. This is a new account so there aren't any servers yet.

![](/images/manage-cloud-servers-cropped.png)

Click "New Cloud Server" to show the dialog box for configuring a new server.

![](/images/manage-new-cloud-server-image-cropped.png)

Here I've chosen a suitable name for my first server and increased the [server type](/reference/glossary/#server_type) to "Mini" which gives us 1GB RAM.

I've also searched the image list below to find the Ubuntu 12.04 release, codenamed "Precise" and selected the 32bit image.

Now click "Create" and your new server will begin building. This usually takes about 15 seconds or so to complete and the status will update automatically when it's ready, so no need to impatiently refresh the page :)

![](/images/manage-cloud-server-list-first-server-cropped.png)

As you can see here, we've built one new server and it's been given the identifier `srv-c3cmw`.

#### Your server is now active

At this point your server is active and if you have an IPv6 internet connection, you can ssh into it directly using the IPv6 dns name. Our official Ubuntu images are pre-installed with a user named `ubuntu`:

    $ ssh -l ubuntu ipv6.srv-c3cmw.gb1.brightbox.com
    The authenticity of host 'ipv6.srv-c3cmw.gb1.brightbox.com (2a02:1348:14c:e18:24:19ff:fef0:3862)' can't be established.
    ECDSA key fingerprint is 19:6d:48:40:63:83:10:53:b1:39:d6:ba:84:1c:20:33.
    Are you sure you want to continue connecting (yes/no)? yes
    
    Welcome to Ubuntu 12.04.2 LTS (GNU/Linux 3.2.0-41-virtual i686)
    
    ubuntu@srv-c3cmw:~$


### Mapping a Cloud IP

To give it a public IPv4 address, you need to map a [Cloud IP](/reference/cloud-ips/) to it.

Click "Cloud IPs" in the sidebar on the left, and click "New Cloud IP".

We want this Cloud IP mapped onto the server we just built, so click the destination select box and select that server from the list. You can also give the IP a descriptive name to help you keep track of it. Click "Create".

![](/images/manage-new-cloud-ip-cropped.png)

A new Cloud IP is now allocated for you and mapped onto your Cloud Server. In this case we've been allocated the IP `109.107.35.95` with the identifier `cip-4bu8v`.

![](/images/manage-cloud-ips-list-cropped.png)

Your server is now accessible by the new Cloud IP, so you can ssh into it:

    $ ssh -l ubuntu 109.107.35.95
    The authenticity of host '109.107.35.95 (109.107.35.95)' can't be established.
    ECDSA key fingerprint is 19:6d:48:40:63:83:10:53:b1:39:d6:ba:84:1c:20:33.
    Are you sure you want to continue connecting (yes/no)? yes
    Warning: Permanently added '109.107.35.95' (ECDSA) to the list of known hosts.
    Welcome to Ubuntu 12.04.2 LTS (GNU/Linux 3.2.0-41-virtual i686)
    
    ubuntu@srv-c3cmw:~$

For convenience there is a dns record that points to the first Cloud IP mapped to a server, in this case `public.srv-c2cmw.gb1.brightbox.com`

    $ host public.srv-c3cmw.gb1.brightbox.com
    public.srv-c3cmw.gb1.brightbox.com has address 109.107.35.95

### Would you like to know more?

Here you used the Brightbox Manager to create an Ubuntu server, mapped a Cloud IP to it and connected in using ssh.

There is another guide for [building a Windows server](/guides/manager/windows-servers/), which covers using the graphical console to set a password.

You might also want to learn more about
[Cloud IPs](/reference/cloud-ips/), or
[discover zones](/reference/glossary/#zone).

Or perhaps you'd prefer to use our [command line interface](/guides/cli/getting-started) to manage your Brightbox Cloud resources?
