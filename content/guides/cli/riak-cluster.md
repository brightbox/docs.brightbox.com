---
layout: default
title: Building a Riak Cluster
section: Guides
---

This guide takes you through building a small four node Riak cluster
on Brightbox Cloud.

### Firewalling

Firstly, let's create a group for the cluster and a firewall policy:

    $ brightbox-groups create -n "riak"
    Creating a new server group
    
     id         server_count  name
    -------------------------------
     grp-ekalx  0             riak
    -------------------------------

    $ brightbox-firewall-policies create -n "riak" grp-ekalx
    
     id         server_group  name
    -------------------------------
     fwp-ev5q6  grp-ekalx     riak
    -------------------------------

Now let's create a few simple firewall rules. We'll allow the Riak
nodes to make unrestricted outgoing connections:

    $ brightbox-firewall-rules create --destination=any fwp-ev5q6
    
     id         protocol  source  sport  destination  dport  icmp_type  description
    --------------------------------------------------------------------------------
     fwr-9h6hs  -         -       -      any          -      -                     
    --------------------------------------------------------------------------------

And we'll allow incoming connections from any other server in the riak
group (so Riak can communicate with itself):

    $ brightbox-firewall-rules create --source=grp-ekalx fwp-ev5q6
    
     id         protocol  source     sport  destination  dport  icmp_type  description
    -----------------------------------------------------------------------------------
     fwr-c8bxd  -         grp-ekalx  -      -            -      -                     
    -----------------------------------------------------------------------------------

And we'll allow incoming ssh access from anywhere so we can manage the
servers:

    $ brightbox-firewall-rules create --source=any --protocol=tcp --dport=22 fwp-ev5q6
    
     id         protocol  source  sport  destination  dport  icmp_type  description
    --------------------------------------------------------------------------------
     fwr-int3c  tcp       any     -      -            22     -                     
    --------------------------------------------------------------------------------

### Building the servers

So now we want to create the servers - a little more preparation first
though. Let's write a little shell script to upgrade any necessary
packages, download Riak, configure and install it:

    #!/bin/sh
    
    ERLANG_COOKIE=Quo1viGheWauch5un4eimohth2ohtheo
    
    # apply any upgrades
    apt-get update
    apt-get upgrade -qy
    # this is handy to have
    apt-get install -qy language-pack-en
    
    # download and install riak package (amd64 version)
    wget http://downloads.basho.com/riak/riak-1.0.2/riak_1.0.2-1_amd64.deb -O /tmp/riak.deb
    dpkg -i /tmp/riak.deb
    
    # Add our hostname to the riak erlang config
    sed -i "s/127.0.0.1/`hostname --long`/" /etc/riak/vm.args
    
    # Set our erlang cookie in the riak erlang config
    sed -i "s/setcookie riak/setcookie $ERLANG_COOKIE/" /etc/riak/vm.args
    
    # Bind the various riak services to all IPs in the riak app config
    sed -i "s/127.0.0.1/0.0.0.0/" /etc/riak/app.config
    
    # Start riak
    /etc/init.d/riak start

Save that locally in a file called `install-riak.sh` and we can
specify it as [user data](/guides/cli/user-data/), which Ubuntu will
execute for us on boot (so we'll need to use an Ubuntu image).

Now we actually create the servers. We'll build two in zone A and two
in zone B so we have geographical redundancy (it's technically a bit
more complicated that that with Riak, but that's out of the scope of
this document!).  We'll put them in the group we created, so they get
the firewall policy we created, we'll use the

We'll create these as `nano` servers, but you should choose an
appropriate server type for your use case (see the `brightbox-types`
command).

    $ brightbox-servers create -n "riak server" -g grp-ekalx -z gb1-a -i 2 -t nano -f install-riak.sh img-3ikco
    Creating 2 nano (typ-4nssg) servers with image Ubuntu Lucid 10.04 server (img-3ikco) in zone gb1-a in groups grp-ekalx with 0.95k of user data
    
     id         status    type  zone   created_on  image_id   cloud_ip_ids  name       
    ------------------------------------------------------------------------------------
     srv-ldpon  creating  nano  gb1-a  2011-12-31  img-3ikco                riak server
     srv-wn8q8  creating  nano  gb1-a  2011-12-31  img-3ikco                riak server
    ------------------------------------------------------------------------------------
    
    $ brightbox-servers create -n "riak server" -g grp-ekalx -z gb1-b -i 2 -t nano -f install-riak.sh img-3ikco
    Creating 2 nano (typ-4nssg) servers with image Ubuntu Lucid 10.04 server (img-3ikco) in zone gb1-b in groups grp-ekalx with 0.95k of user data
    
     id         status    type  zone   created_on  image_id   cloud_ip_ids  name       
    ------------------------------------------------------------------------------------
     srv-hl2fd  creating  nano  gb1-b  2011-12-31  img-3ikco                riak server
     srv-3zdoj  creating  nano  gb1-b  2011-12-31  img-3ikco                riak server
    ------------------------------------------------------------------------------------

The server should become active and start booting within about 30
seconds and they'll execute the contents of the `install-riak.sh`
script, which might take a couple of minutes.

### Mapping a cloud IP

All Brightbox Cloud servers are created with a private IPv4 address
and a public IPv6 address by default.  If you don't have IPv6 then
you'll need to map a Cloud IP to one of your new Riak servers to start
accessing the cluster:

    $ brightbox-cloudips create
    
     id         status    public_ip      destination  reverse_dns                        
    --------------------------------------------------------------------------------------
     cip-gdr5f  unmapped  109.107.37.19               cip-109-107-37-19.gb1.brightbox.com
    --------------------------------------------------------------------------------------
    
    $ brightbox-cloudips map cip-gdr5f srv-3zdoj
    
    Mapping cip-gdr5f to interface int-sh2hm on srv-3zdoj
    
     id         status  public_ip      destination  reverse_dns                        
    ------------------------------------------------------------------------------------
     cip-gdr5f  mapped  109.107.37.19  srv-3zdoj    cip-109-107-37-19.gb1.brightbox.com
    ------------------------------------------------------------------------------------

You can now ssh into that IP address - the firewall will of course
keep the Riak services protected.

I'll be using IPv6 for the rest of this guide though.

### Joining up the cluster

So we now just need to ssh into one of the nodes of the cluster and
tell Riak about all the other nodes in the cluster (Our Ubuntu images
automatically install your ssh keys on first boot, to the `ubuntu` account).

If you're using IPv4 and just one Cloud IP, then you need to ssh into
the server with the Cloud IP and then ssh from there into the
others. With IPv6 you can obviously easily access all the nodes
directly if you wish:

    $ brightbox-servers list -g grp-ekalx
    
     id         status  type  zone   created_on  image_id   cloud_ip_ids  name       
    ----------------------------------------------------------------------------------
     srv-ldpon  active  nano  gb1-a  2011-12-31  img-3ikco                riak server
     srv-wn8q8  active  nano  gb1-a  2011-12-31  img-3ikco                riak server
     srv-hl2fd  active  nano  gb1-b  2011-12-31  img-3ikco                riak server
     srv-3zdoj  active  nano  gb1-b  2011-12-31  img-3ikco  cip-gdr5f     riak server
    ----------------------------------------------------------------------------------
    
    $ ssh -l ubuntu ipv6.srv-ldpon.gb1.brightbox.com
    The authenticity of host 'ipv6.srv-ldpon.gb1.brightbox.com (2a02:1348:14c:18d3:24:19ff:fef0:634e)' can't be established.
    RSA key fingerprint is df:d8:53:e7:2a:7b:21:02:31:db:a9:a0:3b:eb:e7:a6.
    Are you sure you want to continue connecting (yes/no)? yes
    Warning: Permanently added 'ipv6.srv-ldpon.gb1.brightbox.com,2a02:1348:14c:18d3:24:19ff:fef0:634e' (RSA) to the list of known hosts.
    Linux srv-ldpon 2.6.32-31-server #61-Ubuntu SMP Fri Apr 8 19:44:42 UTC 2011 x86_64 GNU/Linux
    
    ubuntu@srv-ldpon:~$ ssh -o StrictHostKeyChecking=no -l ubuntu srv-wn8q8.gb1.brightbox.com sudo riak-admin join riak@srv-ldpon.gb1.brightbox.com
    Warning: Permanently added 'srv-wn8q8.gb1.brightbox.com,10.240.190.210' (RSA) to the list of known hosts.
    Attempting to restart script through sudo -u riak
    Sent join request to riak@srv-ldpon.gb1.brightbox.com
    
    ubuntu@srv-ldpon:~$ ssh -o StrictHostKeyChecking=no -l ubuntu srv-hl2fd.gb1.brightbox.com sudo riak-admin join riak@srv-ldpon.gb1.brightbox.com
    Warning: Permanently added 'srv-hl2fd.gb1.brightbox.com,10.232.68.98' (RSA) to the list of known hosts.
    Attempting to restart script through sudo -u riak
    Sent join request to riak@srv-ldpon.gb1.brightbox.com
    
    ubuntu@srv-ldpon:~$ ssh -o StrictHostKeyChecking=no -l ubuntu srv-3zdoj.gb1.brightbox.com sudo riak-admin join riak@srv-ldpon.gb1.brightbox.com
    Warning: Permanently added 'srv-3zdoj.gb1.brightbox.com,10.232.101.98' (RSA) to the list of known hosts.
    Attempting to restart script through sudo -u riak
    Sent join request to riak@srv-ldpon.gb1.brightbox.com
1
And now the cluster is complete. You can see that all the nodes know about each other:

    ubuntu@srv-ldpon:~$ riak-admin status | grep ring_ownership
    ring_ownership : <<"[{'riak@srv-wn8q8.gb1.brightbox.com',16},\n {'riak@srv-ldpon.gb1.brightbox.com',16},\n {'riak@srv-hl2fd.gb1.brightbox.com',16},\n {'riak@srv-3zdoj.gb1.brightbox.com',16}]">>

FIXME: Show a curl command
FIXME: Double check about quorum and 4 nodes
FIXME: Built "master" server first and have the script do the join for the others?
FIXME: Show how to give web server group access
FIXME: Note that script will run on each boot - perhaps have it check for /etc/riak
