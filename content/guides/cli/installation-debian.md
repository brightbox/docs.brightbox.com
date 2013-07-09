---
layout: default
title: CLI Installation for Debian
section: CLI
---

You can use our Ruby gem package to install the CLI on Debian.

#### Debian Dependencies

You'll need some libraries and headers installed to build the required
native gems. On Debian you can install these with this command:

    $ sudo apt-get install ruby rubygems ruby-dev libxml2-dev libxslt-dev libopenssl-ruby libjson0-dev

You'll need to install a newer version of rubygems than the one currently packaged with Debian. We recommend the
[Tryphon repositories](http://debian.tryphon.eu/).

You should now be ready to [install the CLI Ruby Gem] (/guides/cli/installation-gem/).

