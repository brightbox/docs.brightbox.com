---
layout: default
title: Getting Started with the Brightbox Manager
section: Brightbox Manager
---

The Brightbox Manager is a browser based graphical user interface for managing Brightbox Cloud resources.

It's accessible at [https://manage.brightbox.com](https://manage.brightbox.com). You'll need to have [signed up](https://manage.brightbox.com/signup) for an account.

This guide will take you through building and accessing your first cloud server.

Once logged in, you're presented with the dashboard which gives an overview of your account.

![](/images/manage-dashboard.png)

### Setting an ssh key

If you didn't specify a public ssh key when you first signed up...link.

### Building a server

Click "Cloud Servers" in the sidebar on the left to view the server manager. This is a new account so there aren't any servers yet.

![](/images/manage-cloud-servers-cropped.png)

Click "New Cloud Server" to show the dialog box for configuring a new server.

![](/images/manage-new-cloud-server-image-cropped.png)

Here I've chosen a suitable name for my first server and increased the server type to "Mini" which gives us 1GB RAM.

I've also searched the image list below to find the Ubuntu 12.04 release, codenamed "Precise" and selected the 32bit image.

Now click "Create" and your new server will begin building. This usually takes about 15 seconds or so to complete and the status will update automatically when it's ready, so no need to impatiently refresh the page :)

![](/images/manage-cloud-server-list-first-server-cropped.png)

As you can see here, we've built one new server and it's been given the identifier `srv-c3cmw`.

#### Your server is now active

At this point your server is active and if you have an IPv6 internet connection, you can ssh into it directly using the IPv6 dns name. Our official Ubuntu images are pre-instled with a user named `ubuntu`:

    $ ssh -l ubuntu ipv6.srv-c3cmw.gb1.brightbox.com
    The authenticity of host 'ipv6.srv-c3cmw.gb1.brightbox.com (2a02:1348:14c:e18:24:19ff:fef0:3862)' can't be established.
    ECDSA key fingerprint is 19:6d:48:40:63:83:10:53:b1:39:d6:ba:84:1c:20:33.
    Are you sure you want to continue connecting (yes/no)? yes
    
    Welcome to Ubuntu 12.04.2 LTS (GNU/Linux 3.2.0-41-virtual i686)
    
    ubuntu@srv-c3cmw:~$

