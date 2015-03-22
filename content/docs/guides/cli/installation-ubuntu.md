---
layout: default
title: CLI Installation for Ubuntu
section: CLI
---

To get our CLI running on Ubuntu, you can either install our ruby gem package, or you could use our native Ubuntu package from our package repository

### Native CLI Ubuntu Package

To install the Command Line Interface native Ubuntu package, first add the Brightbox ppa from the Launchpad repository as follows:

    $ sudo add-apt-repository ppa:brightbox/ppa
    $ sudo apt-get update

Then install the cli:

    $ sudo apt-get install brightbox-cli

The CLI is ready to use and you can continue with the [getting started guide](/docs/guides/cli/getting-started/).

### Ruby gem dependencies

Or instead, to install the Command Line Interface as a ruby gem, first install ruby.

#### Ubuntu 10.04 Lucid and 12.04 Precise

Lucid and Precise use Ruby 1.8 by default, so you must install the ruby and rubygems packages:

    $ sudo apt-get install ruby rubygems

#### Ubuntu 14.04 Trusty

Trusty (and other releases newer than Precise, such as Quantal and Saucy) just require the ruby package:

    $ sudo apt-get install ruby

#### Install the CLI Ruby Gem

You should now be ready to [install the CLI Ruby Gem](/docs/guides/cli/installation-gem/).
