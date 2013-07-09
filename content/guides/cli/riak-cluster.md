---
layout: default
title: Building a Riak Cluster
section: CLI
---

This guide takes you through building a small four node
[Riak](http://wiki.basho.com/Riak.html) database cluster on Brightbox
Cloud. It assumes you have already signed up and configured the
command line interface.  If you haven't, follow the
[Getting Started guide](/guides/cli/getting-started/).

### Firewalling

Firstly, let's create a [Server Group](/guides/cli/server-groups/) for
the cluster and a
[Firewall Policy](http://docs.brightbox.com/reference/firewall/):

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

Before we create the servers, there is a little more preparation to
automate the configuration.  Let's write a little shell script to
upgrade any necessary packages, download Riak, configure and install
it:

    #!/bin/sh
		
    SEED_HOST=
    ERLANG_COOKIE=Quo1viGheWauch5un4eimohth2ohtheo

    # Skip if it looks like Riak is already installed
    test -d /etc/riak && exit
    
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
    
    # Join this node to the cluster
    riak-admin join riak@$SEED_HOST

Save that locally in a file called `install-riak.sh` and we can
specify it as [user data](/guides/cli/user-data/), which Ubuntu will
execute for us on boot (so we'll need to use an Ubuntu image). This
script assumes a 64bit server.

Choose your own secret for the `ERLANG_COOKIE` variable.  You'll also
notice the empty `SEED_HOST` variable in that script - we'll fill that
in once we've built our first server.

So now we actually create the servers. We'll build two in Zone A and
two in Zone B so we have geographical redundancy. It's technically a
[bit more complicated](http://wiki.basho.com/Replication.html) than
that with Riak, but that's out of the scope of this document. Though
it is worth noting that Riak doesn't tolerate high latency in this
type of configuration but our [Zones](/reference/glossary/#zone) are
connected by low latency links so we're fine here.


We'll put the new servers in the group we created, so they get the
firewall policy we created.  We'll create them as `nano` servers, but
you should choose an appropriate server type for your use case (see
the `brightbox-types` command).

Let's create our first server which we'll use as the "seed host":

    $ brightbox-servers create -n "riak server" -g grp-ekalx -z gb1-a -t nano -f install-riak.sh img-3ikco
    Creating 1 nano (typ-4nssg) servers with image Ubuntu Lucid 10.04 server (img-3ikco) in zone gb1-a in groups grp-ekalx with 0.95k of user data
    
     id         status    type  zone   created_on  image_id   cloud_ip_ids  name       
    ------------------------------------------------------------------------------------
     srv-ldpon  creating  nano  gb1-a  2011-12-31  img-3ikco                riak server
    ------------------------------------------------------------------------------------

The server will boot, retrieve the contents of `install-riak.sh` and
execute it. So give it a couple of minutes so that Riak gets installed
and is running.

Before we create the other servers, edit the `install-riak.sh` script
and set the `SEED_HOST` variable to the name of this new server:

    SEED_HOST=srv-ldpon.gb1.brightbox.com

We can now build the remaining three servers and they'll automatically
join the cluster:

    $ brightbox-servers create -n "riak server" -g grp-ekalx -z gb1-a -t nano -f install-riak.sh img-3ikco
    Creating 1 nano (typ-4nssg) servers with image Ubuntu Lucid 10.04 server (img-3ikco) in zone gb1-a in groups grp-ekalx with 0.95k of user data
    
     id         status    type  zone   created_on  image_id   cloud_ip_ids  name       
    ------------------------------------------------------------------------------------
     srv-wn8q8  creating  nano  gb1-a  2011-12-31  img-3ikco                riak server
    ------------------------------------------------------------------------------------
    
    $ brightbox-servers create -n "riak server" -g grp-ekalx -z gb1-b -i 2 -t nano -f install-riak.sh img-3ikco
    Creating 2 nano (typ-4nssg) servers with image Ubuntu Lucid 10.04 server (img-3ikco) in zone gb1-b in groups grp-ekalx with 0.95k of user data
    
     id         status    type  zone   created_on  image_id   cloud_ip_ids  name       
    ------------------------------------------------------------------------------------
     srv-hl2fd  creating  nano  gb1-b  2011-12-31  img-3ikco                riak server
     srv-3zdoj  creating  nano  gb1-b  2011-12-31  img-3ikco                riak server
    ------------------------------------------------------------------------------------

The servers should become active and start booting within about thirty
seconds and they'll execute the contents of the `install-riak.sh`
script, which again might take a couple of minutes to complete.

### Mapping a cloud IP

All Brightbox Cloud servers are created by default with a private IPv4
address and a public IPv6 address.  If you don't have IPv6 then you'll
need to map a [Cloud IP](/reference/cloud-ips/) to one of your new
Riak servers to start accessing the cluster:

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

You can now ssh into that server using the cloud ip address.

I'll be using IPv6 because I'm living in the future and have IPv6 at
home. Also I have a robot butler.

### Accessing the cluster

Let's ssh into one of the nodes of the cluster to confirm all the
nodes joined up successfully.  Our Ubuntu images automatically install
your ssh keys to the `ubuntu` account on the first boot, so we can ssh
straight in:

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
    
    ubuntu@srv-ldpon:~$ riak-admin status | grep ring_ownership
    ring_ownership : <<"[{'riak@srv-wn8q8.gb1.brightbox.com',16},\n {'riak@srv-ldpon.gb1.brightbox.com',16},\n {'riak@srv-hl2fd.gb1.brightbox.com',16},\n {'riak@srv-3zdoj.gb1.brightbox.com',16}]">>
		
So we can see all the servers are part of the Riak cluster now, and we
can read and write documents:

Write it to one server:

    ubuntu@srv-ldpon:~$ curl -d 'Hello World' -H 'Content-Type: text/plain' http://srv-ldpon.gb1.brightbox.com:8098/riak/test/hello

Read it from another:

    ubuntu@srv-ldpon:~$ curl http://srv-3zdoj.gb1.brightbox.com:8098/riak/test/hello
    Hello World

### Giving access to another group of servers

So now you have your Riak cluster working, you might want to grant
access to some web servers. Assuming your web servers are in a group
with the identifier `grp-u5qrt` you can give the whole group access to
the Riak HTTP interface on all the riak nodes like this:

    $ brightbox-firewall-rules create --source=grp-u5qrt --protocol=tcp --dport=8098 fwp-ev5q6

