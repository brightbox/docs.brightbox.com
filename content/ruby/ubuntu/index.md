---
layout: default
title: Ruby packages for Ubuntu
---

Brightbox have been providing optimised Ruby 1.8 and Rubygems 1.3.7
packages for Ubuntu for years now but some technical issues prevented
us from providing 1.9.3 packages alongside them. So we started out
afresh from the very latest Debian 1.8.7 and 1.9.3 packages, and
added:

* [Ruby Enterprise Edition](http://www.rubyenterpriseedition.com/) patches for 1.8.7-358 (2012.02)
* Built Ruby 1.9.3 with Google’s high performance memory allocator, tcmalloc
* Added [Sokolov Yura](https://github.com/funny-falcon/ruby)’s performance patches for 1.9.3
* Added Narihiro Nakamura’s [Bitmap Marking garbage collector](http://patshaughnessy.net/2012/3/23/why-you-should-be-excited-about-garbage-collection-in-ruby-2-0) (backported by Sakolov Yura)
* Patched Ruby 1.9.3 to export the right symbols to work with ruby-debug

So this gives you Ruby 1.8.7, Ruby 1.9.3 and Rubygems 1.8.21 on Ubuntu
10.04 Lucid through to the latest LTS Ubuntu 12.04 Precise. You can
install both Ruby 1.8.7 and 1.9.3 alongside each other and switch
between them effortlessly. We’ve also updated our Passenger packages
to work with both versions of Ruby (and our NGINX Passenger packages
too). All available via the same repository.


### Installation

All the above packages are available right now in our
[Launchpad package repository](https://launchpad.net/~brightbox/+archive/ruby-ng). You
can add the repository to your servers like this:

    sudo apt-get install python-software-properties
    sudo apt-add-repository ppa:brightbox/ruby-ng
    sudo apt-get update

and you can install or upgrade ruby like this:

    sudo apt-get install ruby rubygems ruby-switch

If you’re upgrading, some packages have been replaced so you will see
apt removing some packages (such as rubygems1.8, irb1.8 and others) –
don’t panic :)

To install Ruby 1.9.3:

    sudo apt-get install ruby1.9.3

And you can run the different versions of ruby like this:

    $ ruby1.8 -v
    ruby 1.8.7 (2012-02-08 MBARI 8/0x8770 on patchlevel 358) [i486-linux], MBARI 0x8770, Ruby Enterprise Edition 2012.02
    
    $ ruby1.9.3 -v
    ruby 1.9.3p125 (2012-02-16 revision 34643) [i486-linux]
    
    $ gem1.8 install bundler
    
    $ gem1.9.3 install bundler

#### Switching the default Ruby version

You can also switch the default Ruby version back and forth between
1.8 and 1.9.3 using the ruby-switch tool:

    $ ruby -v
    ruby 1.8.7 (2012-02-08 MBARI 8/0x8770 on patchlevel 358) [i486-linux], MBARI 0x8770, Ruby Enterprise Edition 2012.02
    
    $ ruby-switch --list
    ruby1.8
    ruby1.9.1
    
    $ sudo ruby-switch --set ruby1.9.1
    update-alternatives: using /usr/bin/ruby1.9.1 to provide /usr/bin/ruby (ruby) in manual mode.
    update-alternatives: using /usr/bin/gem1.9.1 to provide /usr/bin/gem (gem) in manual mode.
    
    $ ruby -v
    ruby 1.9.3p125 (2012-02-16 revision 34643) [i486-linux]

(note that Ruby 1.9.3 shows as 1.9.1, due to a historical Debian thing
about binary compatibility)


#### Gem binaries

The binaries installed by gems (such as bundler’s “bundle” command)
might not automatically use the current default version of ruby
(preferring the version that was default at the time it was
installed). In that case, you can run it under a specific version like
this:

    $ ruby1.9.1 -S bundle -v
    Bundler version 1.1.3

#### Rubygems Compatibility

Note that some older versions of Rails do not work with the latest
versions of Rubygems - if you're using our Rubygems 1.3.7 packages and
don't want to upgrade them, you can pin them like this:

    cat <<EOF > /etc/apt/preferences.d/rubygems
    Package: rubygems
    Pin: version 1.3.*
    Pin-Priority: 600
    Package: rubygems1.8
    Pin: version 1.3.*
    Pin-Priority: 600
    EOF

#### Passenger Support

Our passenger packages have been updated to support switching between
1.8.7 and 1.9.3. By default it supports 1.8.7, and to add 1.9.3
support just install the package:

    $ sudo apt-get install passenger-common1.9.1

Then you can safely switch the default ruby to 1.9.3, or
[tell Passenger to use it directly](http://www.modrails.com/documentation/Users%20guide%20Apache.html#PassengerRuby).


### Experimental repository

We have a separate
[experimental repository](https://launchpad.net/~brightbox/+archive/ruby-ng-experimental)
that holds test builds.

We recommend only using this experimental repository for testing
purposes. Use the main repository for stable updates.
