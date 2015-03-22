---
layout: default
title: Automatic security updates with unattended-upgrades
---

There's no doubt that the single biggest cause of server compromise is the wide-scale deployment of outdated software.  Security issues are constantly being reported, and fixed, and unless you keep your system(s) up to date there is always the possibility that you'll fall victim to an attack which has been publicly disclosed and subsequently fixed via an update.

### Keeping up-to-date

Thankfully, keeping up to date about security fixes isn't difficult.  The two simple things we'd recommend for all server administrators is:

* Subscribing to the security-announcement list for your distribution.
* Enable the use of automatic package updates.

If you subscribe to the security-announcement mailing list for your distribution you'll be aware of expected updates and the appearance of new security issues in software you might have installed. And if you enable automatic upgrades you'll not actually need to take any action to apply fixes - they'll just happen automatically.

### Automated security updates

Most distributions allow a server to be updated automatically upon the release of new security updates.  For example [Ubuntu](/docs/ubuntu) systems have a package called [unattended-upgrades](http://packages.ubuntu.com/unattended-upgrades) which can be easily configured to apply security updates automatically.

If you have already provisioned a [cloud server](/docs/reference/cloud-servers) running Ubuntu you can install it via:

       $ sudo apt-get install unattended-upgrades
       $ sudo dpkg-reconfigure unattended-upgrades

Once this has been done you'll find your packages will update automatically once per day.  This should severely reduce the chances of a compromise due to publicly disclosed security issues (although it is worth remembering that this will just cover _system_ packages, not any software you install from external sources, such as Wordpress etc.)

### Using cloud-init to setup unattended-upgrades

Using cloud-init, you can also ensure that this is done right from the start of your cloud server's life by adding [user data](/docs/guides/cli/user-data/) script to install the package on first boot.

When creating a new cloud server, using Brightbox Manager, switch to the <q>Advanced</q> tab and enter the following text:

    #!/bin/sh
    apt-get update
    echo unattended-upgrades unattended-upgrades/enable_auto_updates boolean true | debconf-set-selections
    apt-get -y install  unattended-upgrades

This will give you a view like this:

![Automatic updates via meta-data](/images/docs/unattended-upgrades.png)


This will be executed when your server is first launched and will ensure that your system is kept up-to-date from day one.

