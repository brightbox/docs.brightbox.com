---
layout: default
title: CLI Installation for Debian
section: CLI
---

You can use our Ruby gem package to install the CLI on Debian.

#### Debian Wheezy

On Wheezy, all you need is the `ruby` package:

    $ apt-get install ruby

#### Debian Squeeze

On Squeeze, you need the `rubygems` package as well:

    $ apt-get install ruby rubygems

You'll also need to add `/var/lib/gems/1.8/bin` to your `PATH`. Or you could just consider using the
[Tryphon repositories](http://debian.tryphon.eu/) version of rubygems, which handles this for you (and a few other imporvements.

#### Install the CLI Ruby Gem

You should now be ready to [install the CLI Ruby Gem](/docs/guides/cli/installation-gem/).

