---
title: Vagrant
layout: default
tags: vagrant
---

[Vagrant](http://vagrantup.com/) is a tool that allows you to create a
complete development environment with a single command - saving loads
of time and getting you productive sooner.

The Brightbox plugin allows you to create that environment on
Brightbox Cloud as easily as you can locally.

### Install Vagrant

Vagrant is available for Mac OS X, Windows, Debian, Ubuntu, Centos, Redhat and Fedora. The installers and packages are available from the [vagrant download page](http://www.vagrantup.com/downloads).

If you're running Ubuntu 14.04 Trusty, it's as easy as installing the official Ubuntu package, like this:

    $ sudo apt-get install vagrant

### Install the Vagrant Brightbox plugin

To install the brightbox plugin, you may need the libxml and libxslt dependencies. On Ubuntu and Debian, you can get those like this:

    $ sudo apt-get install libxml2-dev libxslt-dev

Then install the plugin:

    $ vagrant plugin install vagrant-brightbox

    Installing the 'vagrant-brightbox' plugin. This can take a few minutes...
    Installed the plugin 'vagrant-brightbox (0.2.0)'!

### Configure your Vagrantfile

Create a new directory for your project, change to it and initialise Vagrant:

    $ vagrant init
    
    A `Vagrantfile` has been placed in this directory. You are now
    ready to `vagrant up` your first virtual environment! Please read
    the comments in the Vagrantfile as well as documentation on
    `vagrantup.com` for more information on using Vagrant.

Then, create a new [API client](/docs/reference/api-clients/) on your Brightbox account and add the credentials to the `Vagrantfile`:

    config.vm.provider :brightbox do |brightbox|
      brightbox.client_id = "cli-abcde"
      brightbox.secret = "yoursecret"
    end

### Setup your ssh key

You'll need to have
[setup a public ssh key](/docs/guides/manager/ssh-keys/) with
Brightbox Cloud so that you can access newly built servers. Then, tell Vagrant to use your private key, by adding this to the `Vagrantfile`:

    config.ssh.private_key_path  = "~/.ssh/yourprivate.key"

### Choose an image to use as a box

Use the [Brightbox Vagrant box index](/vagrant/images/) to find a box definition. For this example we'll select an Ubuntu 12.04 Precise image, and add it as the base box:

    $ vagrant box add base http://brightbox.com/vagrant/img-py9ti.box

    Downloading box from URL: http://brightbox.com/vagrant/img-py9ti.box
    Extracting box...e: 0/s, Estimated time remaining: --:--:--)
    Successfully added box 'base' with provider 'brightbox'!

### Launch a Vagrant server!

Then use `vagrant up` to launch a server. The plugin will automatically create a new Cloud IP and map it to the new machine for you, so you can access it over IPv4 straight away (your default firewall policy will need to allow SSH of course, which is the case unless you've changed the defaults):

    $ vagrant up --provider=brightbox
    
    Bringing machine 'default' up with 'brightbox' provider...
    [default] Launching a server with the following settings
    [default]  -- Image: img-py9ti
    [default]  -- Region: gb1
    [default] Waiting for the server to be built...
    [default] Mapped IPv4 Cloud IP '109.107.xx.xx' to server 'srv-abcde'
    [default] Waiting for SSH to become available...
    Enter passphrase for ~/.ssh/yourprivate.key:
    [default] The server is ready!
    [default] Rsyncing folder: ~/vagrant/ => /vagrant

### Summary

For reference, a minimal `Vagrantfile` for use with Brightbox looks like this:

    Vagrant.configure("2") do |config|
      config.vm.box = "base"
      config.vm.box_url = "http://brightbox.com/vagrant/img-py9ti.box"
      config.ssh.private_key_path  = "~/.ssh/yourprivate.key"
    
      config.vm.provider :brightbox do |brightbox|
        brightbox.client_id = "cli-abcde"
        brightbox.secret = "yourclisecret"
      end
    end

The
[vagrant-brightbox plugin code](https://github.com/NeilW/vagrant-brightbox)
is on Github, feel free contribute!

If you have any problems, drop us a line at
[support@brightbox.com](mailto:support@brightbox.com) or if you think
you found a bug then
[open an issue on Github](https://github.com/NeilW/vagrant-brightbox/issues).