---
layout: default
title: Ruby packages for Ubuntu
---

Brightbox have been providing optimised Ruby packages for Ubuntu for years. We're currently maintaining packages for Ruby 2.2, 2.1, 2.0, 1.9.3, and 1.8.7. Our Ruby 1.9.3 and 1.8.7 packages are modified with various performance improvements.

#### Ruby 2.2

We provide Ruby 2.2 packages for Ubuntu Utopic, Trusty and Precise. Our Ruby 2.2 packages are currently built from unmodified versions of Ruby.

#### Ruby 2.1

We provide Ruby 2.1 packages for Ubuntu Utopic, Trusty and Precise. Our Ruby 2.1 packages are built from unmodified versions of Ruby.

#### Ruby 2.0

We provide Ruby 2.0 packages for Ubuntu Trusty, Precise and Lucid. Our Ruby 2.0 packages are built from unmodified versions of Ruby.

#### Ruby 1.9.3

We provide Ruby 1.9.3 packages for Ubuntu Utopic, Trusty, Precise and Lucid. Our Ruby 1.9.3 packages include some major performance improvements:

* Built with Google’s high performance memory allocator, tcmalloc
* Added [Sokolov Yura](https://github.com/funny-falcon/ruby)’s performance patches
* Added Narihiro Nakamura’s [Bitmap Marking garbage collector](http://patshaughnessy.net/2012/3/23/why-you-should-be-excited-about-garbage-collection-in-ruby-2-0) (backported by Sakolov Yura)
* Greg Price's "require" performance fixes.
* Patched to export the right symbols to work with ruby-debug
* Updated rubygems to latest 1.8.x release

#### Ruby 1.8.7

We provide Ruby 1.8.7 packages for Ubuntu Trusty, Precise and Lucid. Our Ruby 1.8.7 packages include some major improvements:

* [Ruby Enterprise Edition](http://www.rubyenterpriseedition.com/) patches for 1.8.7-358 (2012.02)
* Built with Google’s high performance memory allocator, tcmalloc
* Updated rubygems packages to latest 1.3.x release


### Installation

All the above packages are available from our
[Launchpad package repository](https://launchpad.net/~brightbox/+archive/ruby-ng). 
#### Adding the repository

If you're using Ubuntu 14.04 (Trusty) or newer then you can add the package repository like this:

    sudo apt-get install software-properties-common
    sudo apt-add-repository ppa:brightbox/ruby-ng
    sudo apt-get update

Or if you're on Ubuntu 12.04 (Precise) or older

	sudo apt-get install python-software-properties
    sudo apt-add-repository ppa:brightbox/ruby-ng
    sudo apt-get update

#### Installing the packages

Each version of Ruby has it's own packages - just install the packages for the versions you'd like to use.

So to install Ruby1.8, Ruby 1.9.3 and Ruby 2.2

    sudo apt-get install ruby1.8 ruby1.9.3 ruby2.2

And you can run the different versions of ruby like this:

    $ ruby1.8 -v
    ruby 1.8.7 (2012-02-08 MBARI 8/0x8770 on patchlevel 358) [i486-linux], MBARI 0x8770, Ruby Enterprise Edition 2012.02
    
    $ ruby1.9.3 -v
	ruby 1.9.3p545 (2014-02-24) [x86_64-linux] Brightbox
	
    $ gem1.8 install bundler
    
    $ gem1.9.3 install bundler

#### Switching the default Ruby version

You can also switch the default Ruby version back and forth between versions using the `ruby-switch` tool:

	$ sudo apt-get install ruby-switch

    $ ruby -v
    ruby 1.8.7 (2012-02-08 MBARI 8/0x8770 on patchlevel 358) [i486-linux], MBARI 0x8770, Ruby Enterprise Edition 2012.02
    
    $ ruby-switch --list
    ruby1.8
    ruby1.9.1
    ruby2.0
    ruby2.1
	ruby2.2
	
    $ sudo ruby-switch --set ruby1.9.1
    update-alternatives: using /usr/bin/ruby1.9.1 to provide /usr/bin/ruby (ruby) in manual mode.
    update-alternatives: using /usr/bin/gem1.9.1 to provide /usr/bin/gem (gem) in manual mode.
    
    $ ruby -v
	ruby 1.9.3p545 (2014-02-24) [x86_64-linux] Brightbox

(note that Ruby 1.9.3 shows as 1.9.1, due to a historical Debian thing
about binary compatibility)


#### Gem binaries

Any binaries installed by gems (such as bundler’s `bundle` command)
might not automatically use the current default version of ruby
(preferring the version that was default at the time it was
installed). In that case, you can explicitly run it under a specific version like this:

    $ ruby1.9.1 -S bundle -v
	Bundler version 1.6.3

If you're using multiple versions of ruby on a server, it's best to explicitly run any ruby binaries with the desired version of Ruby like this.

#### Ruby 1.8 gems

The ruby 1.8 packages don't come with the rubygems libraries, so you need to install that separately if you need it:

	$ sudo apt-get install ruby1.8 rubygems

Note that some very old versions of Rails do not work with the latest
versions of Rubygems - if you're using our rubygems 1.3.7 packages and
don't want to upgrade, you can pin them like this:

    cat <<EOF > /etc/apt/preferences.d/rubygems
    Package: rubygems
    Pin: version 1.3.*
    Pin-Priority: 600
    Package: rubygems1.8
    Pin: version 1.3.*
    Pin-Priority: 600
    EOF


#### Passenger Support

It's now recommended to use Phusion's own [Ubuntu packages for Passenger](https://www.phusionpassenger.com/install_debian) (we helped develop them, so we know they're alright ;)

### Mailing List

If you have any feedback or comments, or just want to follow along with the latest announcements, join the [Google Groups list](https://groups.google.com/forum/#!forum/brightbox-ruby-ubuntu-packaging). All feedback is always welcome - we like to hear from you even if everything worked ok.

### Experimental repository

We have a separate
[experimental repository](https://launchpad.net/~brightbox/+archive/ruby-ng-experimental)
that holds test builds.

We recommend only using this experimental repository for testing
purposes. Use the main repository for stable updates.
