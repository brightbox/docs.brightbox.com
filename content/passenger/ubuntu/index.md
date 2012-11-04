---
layout: default
title: Passenger on Ubuntu
---

Brightbox maintain Ubuntu packages for Phusion Passenger - the Apache
'mod_rails' hosting solution written by the team at
[Phusion](http://www.phusion.nl/).

If you're using our [Ubuntu Ruby "NG" Packages](/ruby/ubuntu/) then
you can just skip to the installation section - you don't need to add
another repository.

If you'd rather just use only our passenger packages, then you can use
our passenger specific repository:

    sudo apt-add-repository ppa:brightbox/passenger
    sudo apt-get update

#### Ubuntu 8.04 Hardy

If you're on the older Ubuntu 8.04 Hardy release, the
`apt-add-repository` command isn't available so you have to install
the repository and the key by hand:

    sudo sh -c 'echo "deb http://ppa.launchpad.net/brightbox/passenger/ubuntu hardy main" > /etc/apt/sources.list.d/brightbox-passenger.list'
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C3173AA6
    sudo apt-get update

### Installation

    sudo apt-get install libapache2-mod-passenger

And then reload apache and you're ready to go.

### NGINX

We have a separate repository for the nginx packages - again, you
don't need this if you're using our Ruby package repository:

    sudo apt-add-repository ppa:brightbox/passenger-nginx
    sudo apt-get update

Then installed nginx:

    sudo apt-get install nginx-full

You’ll then need to enable the Passenger module, which can be usually
done like this:

    cat <<EOF > /etc/nginx/conf.d/passenger.conf
    passenger_root /usr/lib/phusion-passenger;
    EOF

### Brightbox Ubuntu Packages

To take full advantage of Passenger, you should use our [Ubuntu Ruby
packages](/ruby/ubuntu/). They have copy-on-write support patched in
which means your app will use much less ram.

## Experimental Passenger 4 packages

We're currently working on packages for the upcoming Passenger 4
([currently in beta](http://blog.phusion.nl/2012/10/24/phusion-passenger-4-0-beta-1-is-here/)). You
can help test these packages, but be warned that they might be buggy
(and they currently only work with Apache):

    sudo apt-add-repository ppa:brightbox/passenger-experimental
    sudo apt-get update
    sudo apt-get install libapache2-mod-passenger

All the separate passenger-common packages have just merged into one
package named `ruby-passenger`. The packages are currently built only
for Ubuntu Lucid, Oneiric and Precise and will work with or without
our [Ubuntu Ruby packages](/ruby/ubuntu) (though we'd recommend
them!).

Please send success stories or bug reports to support@brightbox.com.
