---
layout: default
title: Bootstrapping servers with cloud-init
---

`cloud-init` is a tool preinstalled on our Ubuntu images that runs on first boot and prepares a newly built server for first use.

Its main responsibility is to retrieve your public ssh keys from our [metadata service](/docs/reference/metadata-service/) and install them on the `ubuntu` users, so you can log in.

But it does a few other important things, and can be instructed to do much more by setting some specially formatted [user data](/docs/guides/cli/user-data/) when you create your server.

Full documentation for cloud-init is available [on the ubuntu help page](https://help.ubuntu.com/community/CloudInit), but here are a few useful examples.

### Growing the root partition and filesystem

Brightbox Cloud Ubuntu images are built with a small partition and cloud-init auto-grows it and the file system to whatever your server type disk size is on boot. And if you snapshot a small server and build a larger server from it, the partition and filesystem will grow again.

You can control this behaviour with some user data:

    #cloud-config
    growpart:
      mode: off

### Install and run puppet

Cloud-init can be made to install and configure puppet:

    #cloud-config
    puppet:
      conf:
      agent:
        server: "puppetmaster.example.org"

### Add a package repository and install packages

Cloud-init can be made to configure custom apt repositories and install packages:

    #cloud-config
    package_update: true
    apt_sources:
      - source: "ppa:brightbox/ruby-ng"
    packages:
      - ruby2.1
      - apache2

### Run arbitrary commands

And cloud-init can just be given some arbitrary commands to run on boot, giving you complete control:

    #cloud-config:
    runcmd:
      - wget https://example.com/
      - ping -c1 example.com
      - apt-get -y install chef



