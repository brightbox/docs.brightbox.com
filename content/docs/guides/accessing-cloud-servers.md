---
layout: default
title: Accessing a new Cloud Server
tags: ssh
keywords: access, login, authentication, password, key, ssh, username
---

### What is the IP address of my new Cloud Server?

By default, all Cloud Servers get a private IPv4 address (which you can find by resolving the fqdn, such as `srv-xxxxx.gb1.brightbox.com`) and a public IPv6 address (`ipv6.srv-xxxxx.gb1.brightbox.com`). More details are available on the [network reference page](/docs/reference/network/).

To give a Cloud Server a public IPv4 address, you need to map a [Cloud IP](/docs/reference/cloud-ips/) to it.

### What username do I use to log in to my new Cloud Server?

<img src="/images/docs/image-details.png" alt="" class="doc-right doc-border" />

The account name to use to log in depends on the image used to build the server. For Ubuntu images, the username is usually `ubuntu`, Fedora is `fedora` but the Centos images happen to have the username `brightbox`.

You can usually find the image's username displayed in the image details.

If you're using one of our Microsoft Windows images, the username is always `Administrator`.

### Automatic ssh key installation

<img src="/images/docs/manage-ssh-key.png" alt="" class="doc-right doc-border" />

Most Linux images, in particular the official Ubuntu, Centos and Fedora images, automatically install your public ssh key when they first boot up.

You can then login using your private ssh key.

You're asked for your public ssh key when you first sign up and you can change it in the [user menu](https://manage.brightbox.com/user/ssh_key) (or via the CLI).

### How do I generate an SSH key?

You can generate an SSH using the [`ssh-keygen`](https://help.ubuntu.com/community/SSH/OpenSSH/Keys) command line tool. Or, if you're on Windows, you can use [Putty](http://katsande.com/using-puttygen-to-generate-ssh-private-public-keys).

### I added or changed my key but I still can't log in

Adding or changing your ssh key doesn't automatically update it on existing servers - they usually only install your key on first boot. So only newly created servers will get your new key.

### I lost my private ssh key, how can I regain access to my Cloud Server?

You're going to have to use our [graphical console](/docs/guides/manager/graphical-console/) to boot your server in a rescue mode. Different operating systems have different rescue modes, so you'll need to refer to the relevant documentation.

For example, you can access [Ubuntu's recovery mode](https://wiki.ubuntu.com/RecoveryMode) by holding shift during boot.

### How do I get root access?

If the image you're using provides a non-privileged account for login (such as `ubuntu`) then they're usually configured to allow root access using the `sudo` command.

<img src="/images/docs/windows-first-time-password.jpg" alt="" class="doc-right doc-border" />

### How do I access my new Windows Cloud Server?

Our Microsoft Windows 2008 images do not use your ssh keys for authentication. Instead, you need to use our [graphical console](/docs/guides/manager/graphical-console/) to access the Windows login system and [set a first time password](/docs/guides/cli/windows-servers/#setting-the-administrator-password).

<br class="clear"/>

### I messed up a config and broke my server, how do I fix it?

You can [boot into a system rescue environment using PXE](/docs/guides/rescuing-an-unbootable-cloud-server).
