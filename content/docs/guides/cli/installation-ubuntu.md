---
layout: default
title: CLI Installation for Ubuntu
section: CLI
---

To get our CLI running on Ubuntu, just install our Ruby gem package:

First install Ruby 1.9.3 or newer, if you don't have it already:

#### Ubuntu 14.04 Trusty

Trusty and newer use version 1.9.3 by default, so just install the `ruby`
package:

    #!shell
    $ sudo apt-get install ruby

#### Ubuntu 12.04 Precise

Ubuntu Precise uses Ruby 1.8 by default, so you must explicitly install the
`ruby1.9.3` package:

    #!shell
    $ sudo apt-get install ruby1.9.3

#### Install the CLI Ruby Gem

You should now be ready to [install the CLI Ruby Gem](/docs/guides/cli/installation-gem/).
