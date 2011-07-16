---
layout: default
title: User Data
---

Every server has access to it's own metadata via the EC2 compatible
metadata_server. Data such as hostname, instance-id and ssh keys are
available and can be used by scripts to configure the server on boot
(this is how our default images install your ssh key on boot).

You can also provide your own custom user data when creating a server
which can be used in any way you like. The only limitation is that it
can't be larger than 16k in size.


## Hello World example

Firstly, create a new server with "hello world" as the user data. You
can use any image, but I'm going to use Ubuntu Lucid:

    $ brightbox-servers create --user-data "Hello World" img-hm6oj
    Creating a nano (typ-4nssg) server with image Ubuntu Lucid 10.04 server (img-hm6oj) with 0k of user data
    
     id         status    type  zone   created_on  image_id   cloud_ips  name
    --------------------------------------------------------------------------
     srv-agvxl  creating  nano  gb1-b  2010-11-21  img-hm6oj                 
    --------------------------------------------------------------------------

Once it's active, map a cloud IP to it:

    $ brightbox-cloudips map cip-3b0ha srv-agvxl
    Mapping cip-3b0ha to interface int-nmgcx on srv-agvxl
    
     id         status  public_ip       server_id  interface_id  reverse_dns                         
    --------------------------------------------------------------------------------------------------
     cip-3b0ha  mapped  109.107.35.239  srv-agvxl  int-nmgcx     cip-109-107-35-239.gb1.brightbox.com
    --------------------------------------------------------------------------------------------------

Then ssh in and grab the user data using curl:

    $ ssh ubuntu@public.srv-agvxl.gb1.brightbox.com
    ubuntu@srv-agvxl:~$ curl http://169.254.169.254/latest/user-data
    Hello World


## Usage patterns

The usual usage pattern for user data is to rig up an image to grab
the data on boot and do something with it. You could set a bash script
as the user data and execute it on boot, or you could put your puppet
or chef server IP address in the user data field and use it on boot
for registering your new node.

## Ubuntu cloud-init support

Our official Ubuntu images are pre-installed with the cloud-init
package, which runs on boot and can be controlled in different ways
via the user data. Full documentation on what cloud-init can do is
available on the Ubuntu wiki, but here's a neat example of it's shell
script support.


### Basic Ubuntu cloud-init example
Firstly, create a shell script we want to run on boot. In this case we want to install a web server and generate a page to serve:

    $ cat > ud-test-script.sh <<EOF
    #!/bin/sh
    apt-get update
    apt-get install -qy nginx
    invoke-rc.d nginx start
    echo "Hello from the Brightbox Cloud at `date`" > /var/www/index.html
    # Maverick and Lucid use different paths by default
    cp /var/www/index.html /var/www/nginx-default/
    EOF

Then create a new server with an Ubuntu image, specifying the shell script as user data:

    $ brightbox-servers create --user-data-file ud-test-script.sh img-9vxqi
    Creating a nano (typ-4nssg) server with image Ubuntu Maverick 10.10 server (img-9vxqi) with 0k of user data
    
     id         status    type  zone   created_on  image_id   cloud_ips  name
    --------------------------------------------------------------------------
     srv-q1pj6  creating  nano  gb1-b  2010-11-21  img-9vxqi                 
    --------------------------------------------------------------------------

Once it's active, map a cloud IP to it:

    $ brightbox-cloudips map cip-1um8s srv-q1pj6
    Mapping cip-1um8s to interface int-1rb7h on srv-q1pj6
    
     id         status  public_ip       server_id  interface_id  reverse_dns                         
    --------------------------------------------------------------------------------------------------
     cip-1um8s  mapped  109.107.35.140  srv-q1pj6  int-1rb7h     cip-109-107-35-140.gb1.brightbox.com
    --------------------------------------------------------------------------------------------------

Then load the web page to prove the script executed:

    $ curl public.srv-q1pj6.gb1.brightbox.com
    Hello from the Brightbox Cloud at Sun Nov 21 21:19:12 GMT 2010

