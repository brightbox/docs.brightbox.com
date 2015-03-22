---
layout: default
title: Building a CoreOS Cluster
section: CLI
tags: [coreos]
---

This guide takes you through building a [CoreOS cluster](http://coreos.com/) on Brightbox Cloud. It assumes you have already signed up and configured the command line interface. If you haven't, follow the
[Getting Started guide](/docs/guides/cli/getting-started/).

Everything here can also be achieved with the [Brightbox Manager](/docs/guides/manager/) graphical user interface.

### Setting up the firewall policy

First of all, let's create a server group to put the new servers into:

    $ brightbox groups create -n "coreos"
    
    Creating a new server group
    
     id         server_count  name  
    ---------------------------------
     grp-cdl6h  0             coreos
    ---------------------------------

And then create a [firewall policy](/docs/guides/cli/firewall/) for the group using its identifier:

    $ brightbox firewall-policies create -n "coreos" grp-cdl6h
    
     id         server_group  name  
    ---------------------------------
     fwp-dw0n6  grp-cdl6h     coreos
    ---------------------------------

#### Firewall rules

Now let's define the firewall rules for this new policy. First we'll allow ssh access in from anywhere:

    $ brightbox firewall-rules create --source any --protocol tcp --dport 22 fwp-dw0n6
    
     id         protocol  source  sport  destination  dport  icmp_type  description
    --------------------------------------------------------------------------------
     fwr-i513z  tcp       any     -      -            22     -                     
    -------------------------------------------------------------------------------- 

And then we'll allow the CoreOS etcd ports `7001` and `4001`, allowing access from only the other nodes in the group.

    $ brightbox firewall-rules create --source grp-cdl6h --protocol tcp --dport 7001,4001 fwp-dw0n6
    
     id         protocol  source     sport  destination  dport      icmp_type  description
    ---------------------------------------------------------------------------------------
     fwr-xax48  tcp       grp-cdl6h  -      -            7001,4001  -                     
    --------------------------------------------------------------------------------------- 

And then allow all outgoing access from the servers in the group:

    $ brightbox firewall-rules create --destination any fwp-dw0n6
    
     id         protocol  source  sport  destination  dport  icmp_type  description
    --------------------------------------------------------------------------------
     fwr-dtzim  -         -       -      any          -      -                     
    -------------------------------------------------------------------------------- 

### Find the CoreOS server image

At this stage, we could download the CoreOS [OpenStack image](http://storage.core-os.net/coreos/amd64-generic/) (which works on Brightbox Cloud) and [register it](/docs/guides/cli/image-library/) with the image libary which is pretty easy to do, but we're currently providing a CoreOS image for testing with so you can just use that. You can find it by listing all images and grepping for CoreOS:

    $ brightbox images list | grep CoreOS
    
     id         owner      type      created_on  status   size   name
	 ---------------------------------------------------------------------------------------------------------
     img-9ogji  brightbox  official  2013-12-15  public   5442   CoreOS 147.0.1 (x86_64)

### Build the servers

Before building the cluster, we need to generate a unique identifier for it, which is used by CoreOS to discover and identify nodes.

You can use any random string so we'll use the `uuid` tool here to generate one:

    $ TOKEN=`uuid`
    
    $ echo $TOKEN
    53cf11d4-3726-11e3-958f-939d4f7f9688

Then build three servers using the image, in the server group we created and specifying the token as the user data:

    $ brightbox servers create -i 3 --type small --name "coreos" --user-data $TOKEN --server-groups grp-cdl6h img-9ogji

    Creating 3 small (typ-8fych) servers with image CoreOS 94.0.0 (img-9ogji) in groups grp-cdl6h with 0.05k of user data
    
     id         status    type   zone   created_on  image_id   cloud_ip_ids  name  
    --------------------------------------------------------------------------------
     srv-ko2sk  creating  small  gb1-a  2013-10-18  img-9ogji                coreos
     srv-vynng  creating  small  gb1-a  2013-10-18  img-9ogji                coreos
     srv-7tf5d  creating  small  gb1-a  2013-10-18  img-9ogji                coreos
    --------------------------------------------------------------------------------


### Accessing the cluster

Those servers should take just a minute to build and boot. They automatically install your Brightbox Cloud ssh key on bootup, so you can ssh in straight away as the `core` user.

If you've got ipv6 locally, you can ssh in directly:

    $ ssh core@ipv6.srv-n8uak.gb1.brightbox.com
    The authenticity of host 'ipv6.srv-n8uak.gb1.brightbox.com (2a02:1348:17c:423d:24:19ff:fef1:8f6)' can't be established.
    RSA key fingerprint is 99:a5:13:60:07:5d:ac:eb:4b:f2:cb:c9:b2:ab:d7:21.
    Are you sure you want to continue connecting (yes/no)? yes
    
    Last login: Thu Oct 17 11:42:04 UTC 2013 from srv-4mhaz.gb1.brightbox.com on pts/0
       ______                ____  _____
      / ____/___  ________  / __ \/ ___/
     / /   / __ \/ ___/ _ \/ / / /\__ \
    / /___/ /_/ / /  /  __/ /_/ /___/ /
    \____/\____/_/   \___/\____//____/
    core@srv-n8uak ~ $

If you don't have ipv6, you'll need to [create and map a Cloud IP](/docs/guides/cli/cloud-ips/) first.

### Testing out etcd

The [CoreOS guide](http://coreos.com/docs/guides/) takes you though playing with the etcd service:

    $ curl -L http://127.0.0.1:4001/v1/keys/message -d value="Hello world"
    {"action":"SET","key":"/message","prevValue":"Hello world","value":"Hello world","index":12}
    
    $ curl -L http://127.0.0.1:4001/v1/keys/message
    {"action":"GET","key":"/message","value":"Hello world","index":12}


Or you could kick off some [docker containers](http://coreos.com/docs/guides/#container-management-with-docker):

    $ docker run busybox /bin/echo hello world
	Unable to find image     'busybox' (tag: latest) locally
	Pulling repository busybox
	e9aa60c60128: Download complete
	hello world

