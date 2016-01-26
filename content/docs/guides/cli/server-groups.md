---
layout: default
title: Server Groups
section: CLI
---

Server Groups let you logically organise your Cloud Servers. They're the foundation of other Brightbox Cloud services, such as the [Cloud Firewall](/docs/guides/cli/firewall/).

You manage Server Groups with the `brightbox groups` command

    #!shell
    $ brightbox groups list
    
     id         server_count  name                    
    ---------------------------------------------------
     grp-98v4n  4             default                 
    ---------------------------------------------------
		
All accounts have a group named `default` that all new servers are added to unless you specify otherwise as you create them.

### Creating new groups

Let's create two new groups, one for some web servers and one for some database servers.

    #!shell
    $ brightbox groups create -n "web servers"
    Creating a new server group
    
     id         server_count  name       
    --------------------------------------
     grp-f4rpy  0             web servers
    --------------------------------------
    
    $ brightbox groups create -n "db servers"
    Creating a new server group
    
     id         server_count  name      
    -------------------------------------
     grp-ncapg  0             db servers
    -------------------------------------
    
    $ brightbox groups list
    
     id         server_count  name                    
    ---------------------------------------------------
     grp-98v4n  4             default                 
     grp-f4rpy  0             web servers             
     grp-ncapg  0             db servers              
    ---------------------------------------------------

### Adding servers to a group

Then we'll add the servers to the appropriate group. Adding them leaves them in the default group too:

    #!shell
    $ brightbox servers list
    
     id         status    type    zone   created_on  image_id   cloud_ip_ids  name       
    -------------------------------------------------------------------------------------
     srv-13y2j  active    mini    gb1-a  2011-09-25  img-4gqhs                web1       
     srv-25adm  active    mini    gb1-b  2011-09-26  img-4gqhs                web2       
     srv-uj1wm  active    large   gb1-a  2011-10-10  img-4gqhs                db-a       
     srv-5x0ct  active    large   gb1-b  2011-10-11  img-4gqhs                db-b
    -------------------------------------------------------------------------------------
    
    $ brightbox groups add_servers grp-f4rpy srv-13y2j srv-25adm
    Adding 2 servers to server group grp-f4rpy
    
    $ brightbox groups add_servers grp-ncapg srv-uj1wm srv-5x0ct
    Adding 2 servers to server group grp-ncapg
    
    $ brightbox groups list
    
     id         server_count  name                    
    ---------------------------------------------------
     grp-98v4n  4             default                 
     grp-f4rpy  2             web servers             
     grp-ncapg  2             db servers              
    ---------------------------------------------------

### Specifying a group when creating a server

So now we have the two web servers in the `web servers` group, and the two database servers in the `db servers` group. All four servers are also in the default group.  Let's create a new web server and put it straight into the `web servers` group:

    #!shell
    $ brightbox servers create -t mini -n "web3" -g grp-f4rpy img-4gqhs
    
    Creating a mini (typ-iqisj) server with image Ubuntu Lucid 10.04 server (img-4gqhs) in groups grp-f4rpy
    
     id         status    type  zone   created_on  image_id   cloud_ip_ids  name
    -----------------------------------------------------------------------------
     srv-abxcu  creating  mini  gb1-a  2011-10-31  img-4gqhs                web3
    -----------------------------------------------------------------------------
    
    $ brightbox groups list
    
     id         server_count  name                    
    ---------------------------------------------------
     grp-98v4n  4             default                 
     grp-f4rpy  3             web servers             
     grp-ncapg  2             db servers              
    ---------------------------------------------------

Notice that the new server did not go into the `default` group - it was added only to the `web servers` group.

### Removing servers from a group

Let's now remove all the servers from the default group. We can get all the ids of the servers in a group using the `brightbox groups show` command.


    #!shell
    $ brightbox groups show grp-98v4n
    
                 id: grp-98v4n
               name: default
            servers: srv-13y2j srv-25adm srv-uj1wm srv-5x0ct
    firewall_policy: fwp-hvik9
        description: All new servers are added to this group unless specified otherwise.
    
    $ brightbox groups remove_servers grp-98v4n srv-13y2j srv-25adm srv-uj1wm srv-5x0ct
    
    Removing 4 servers from server group grp-98v4n
    
     id         server_count  name   
    ----------------------------------
     grp-98v4n  0             default
    ----------------------------------

    $ brightbox groups list
		
     id         server_count  name                    
    ---------------------------------------------------
     grp-98v4n  0             default                 
     grp-f4rpy  3             web servers             
     grp-ncapg  2             db servers              
    ---------------------------------------------------


Rather than add servers to one group and then remove them from the other, we could have just used the `brightbox groups move_servers` command, which has the same overall result.

### Firewalling

See the [Cloud Firewall guide](/docs/guides/cli/firewall/) on how to control access to, from and between groups.

