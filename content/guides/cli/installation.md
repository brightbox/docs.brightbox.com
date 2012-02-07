---
layout: default
title: CLI Installation
---

The Command Line Interface is available for installation in two forms,
a Ruby gem or an Ubuntu package.

### Ubuntu package installation

The simplest way for an Ubuntu user to install the cli is via our
package repository on Launchpad:

    $ add-apt-repository ppa:brightbox/ppa
    $ apt-get update
    $ apt-get install brightbox-cli

### Ruby gem installation

If you're not on Ubuntu, you can install our Ruby gem package instead.

#### Dependencies

You'll need some libraries and headers installed to build the required
native gems. On Debian and Ubuntu, you can install these like this:

    $ sudo apt-get install ruby rubygems ruby-dev libxml2-dev libxslt-dev libopenssl-ruby libjson0-dev

Debian should be the same as Ubuntu, though you'll need to install a
newer version of rubygems. We recommend the
[Tryphon repositories](http://debian.tryphon.eu/).

On Fedora you should be able to install them like this:

    $ sudo yum install ruby rubygems ruby-devel make gcc libxslt-devel libxml2-devel

On OSX, you just need XCode installed, which provides everything you
need.

#### Install the gem

    $ gem install brightbox-cli
    Fetching: json-1.4.6.gem (100%)
    Building native extensions.  This could take a while...
    Fetching: json_pure-1.4.6.gem (100%)
    Fetching: gli-1.2.5.gem (100%)
    Fetching: hirb-0.3.5.gem (100%)
    Fetching: formatador-0.0.16.gem (100%)
    Fetching: excon-0.5.6.gem (100%)
    Fetching: ini-0.1.1.gem (100%)
    Fetching: brightbox-cli-0.13.gem (100%)
    Successfully installed json-1.4.6
    Successfully installed json_pure-1.4.6
    Successfully installed gli-1.2.5
    Successfully installed hirb-0.3.5
    Successfully installed formatador-0.0.16
    Successfully installed excon-0.5.6
    Successfully installed ini-0.1.1
    Successfully installed brightbox-cli-0.13
    8 gems installed

#### Binaries path

Debian and Ubuntu rubygems packages don't have the rubygems binary
path installed by default, so you need to add it:

    export PATH=$PATH:/var/lib/gems/1.8/bin

Under OSX, if you installed the gem system-wide using sudo, then the
binaries should already be in your path. If you installed the gem
without sudo on OSX, then you need to update your path:

    export PATH=$PATH:~/.gem/ruby/1.8/bin

