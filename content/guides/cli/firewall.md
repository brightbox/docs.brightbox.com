---
layout: default
title: Cloud Firewall
section: Guides
---

The Brightbox Cloud Firewall provides a highly-configurable facility to control access to, from and between your Cloud Servers.  Rather than laboriously writing rules for every one of your Cloud Servers, you define rules for your [Server Groups](/guides/cli/server-groups/). Then, whenever you add servers to the groups, all the rules are applied to all the relevant servers automatically.

Let's set up firewalling for an example web cluster. We have two web servers and two database servers.

The web servers need HTTP and HTTPS ports accessible from the Internet, and the database servers need MySQL ports accessible from only the web servers.

All the servers need to be accessible via ssh from our home Internet connection.

You'll need version `0.15` or higher of the [brightbox cli](/guides/cli/getting-started/) to follow this guide.

### Grouping the Servers

First off, we need to create two [Server Groups](/reference/glossary/#server_group), one for the web servers and one for the database servers. Managing Server Groups is explained in more detail in the [Server Groups Guide](/guides/cli/server-groups/).


    $ brightbox-groups create -n "web servers"
    
    $ brightbox-groups create -n "db servers"
    
    $ brightbox-groups list
    
     id         server_count  name                    
    ---------------------------------------------------
     grp-98v4n  4             default                 
     grp-f4rpy  0             web servers             
     grp-ncapg  0             db servers              
    ---------------------------------------------------

So now we have two new groups, in addition to the default group.  If we moved the servers into these groups now, they'd be cut off completely because we've not defined any rules for them yet. So let's setup the rules first.

### Creating Firewall Policies

Firewall Rules are added to a [Firewall Policy](/reference/glossary/#firewall_policy), rather than directly onto a Server Group. The Firewall Policy is then applied to the Server Group.

So let's create two new firewall policies and map them to the new groups:

    $ brightbox-firewall-policies create -n "web access"
    
     id         server_group  name      
    -------------------------------------
     fwp-emldu                web access
    -------------------------------------
    
    $ brightbox-firewall-policies apply fwp-emldu grp-f4rpy
    
     id         server_group  name      
    -------------------------------------
     fwp-emldu  grp-f4rpy     web access
    -------------------------------------
    
    $ brightbox-firewall-policies create -n "db access"
    
     id         server_group  name     
    ------------------------------------
     fwp-7d4mt                db access
    ------------------------------------
    
    $ brightbox-firewall-policies apply fwp-7d4mt grp-ncapg
    
     id         server_group  name     
    ------------------------------------
     fwp-7d4mt  grp-ncapg     db access
    ------------------------------------
    
    $ brightbox-firewall-policies list
    
     id         server_group  name                     
    ----------------------------------------------------
     fwp-hvik9  grp-98v4n     default                  
     fwp-emldu  grp-f4rpy     web access               
     fwp-7d4mt  grp-ncapg     db access                
    ----------------------------------------------------


### Creating the web server rules

So now we can define the allowed traffic. Let's add the incoming HTTP rule:

    $ brightbox-firewall-rules create --source=any --protocol=tcp --dport=80,443 fwp-emldu
    
     id         protocol  source  sport  destination  dport   icmp_type
    --------------------------------------------------------------------
     fwr-44bgd  tcp       any     -      -            80,443  -        
    --------------------------------------------------------------------

Firewall rules are written from the perspective of the group that the policy is applied to.

So, firewall rules don't have an explicit direction - you don't say this rule is inbound or outbound. Instead, the direction of a rule depends on whether you set the source address or the destination address (you cannot set both).

If you set the source address for a rule, then the **destination** is the group that this policy is applied to.  If you set the destination address, then the **source** becomes the group.

So don't think in terms of inbound or outbound, think: is this rule matching traffic destined somewhere (outgoing) or is it matching traffic from somewhere (incoming).

So in this case, we set the source to `any`, which means any ipv4 or ipv6 address, so it's matching traffic from anywhere in to servers in the `web servers` group.

For high security configurations, we would now define the outgoing access very specifically, perhaps allowing them access to external APIs and SMTP relays or whatever. But for simplicitly here, we'll just add a rule allowing all access:

    $ brightbox-firewall-rules create --destination=any fwp-emldu
    
     id         protocol  source  sport  destination  dport  icmp_type
    -------------------------------------------------------------------
     fwr-chy4h  -         -       -      any          -      -        
    -------------------------------------------------------------------

So now we can see the two rules:

    $ brightbox-firewall-rules list fwp-emldu
    
     id         protocol  source  sport  destination  dport   icmp_type
    --------------------------------------------------------------------
     fwr-44bgd  tcp       any     -      -            80,443  -        
     fwr-chy4h  -         -       -      any          -       -        
    --------------------------------------------------------------------

### Creating the database server rules

Let's add the same outgoing rule for the database servers:

    $ brightbox-firewall-rules create --destination=any fwp-7d4mt
    
     id         protocol  source  sport  destination  dport  icmp_type
    -------------------------------------------------------------------
     fwr-kohyq  -         -       -      any          -      -        
    -------------------------------------------------------------------

And now we'll add the rule to allow the web servers to access MySQL. We just need to specify the `web servers` group id as the source, protocol `tcp` and destination port `3306`. We of course need to add this rule to the `db access` policy that we applied to the `db servers` group:

    $ brightbox-firewall-rules create --source=grp-ncapg --protocol=tcp --dport=3306 fwp-7d4mt
    
     id         protocol  source     sport  destination  dport  icmp_type
    ----------------------------------------------------------------------
     fwr-v66e4  tcp       grp-ncapg  -      -            3306   -        
    ----------------------------------------------------------------------

### Moving the servers

Right, now let's get the firewall rules active for our servers.  We have two web servers and two database servers:

    $ brightbox-servers list
    
     id         status    type    zone   created_on  image_id   cloud_ip_ids  name       
    -------------------------------------------------------------------------------------
     srv-13y2j  active    mini    gb1-a  2011-09-27  img-4gqhs                web1       
     srv-25adm  active    mini    gb1-b  2011-09-28  img-4gqhs                web2       
     srv-uj1wm  active    large   gb1-a  2011-09-25  img-4gqhs                db-a  
     srv-5x0ct  active    large   gb1-b  2011-09-26  img-4gqhs                db-b
    -------------------------------------------------------------------------------------

And they're all currently in the `default` server group:

    $ brightbox-groups list
    
     id         server_count  name                    
    ---------------------------------------------------
     grp-98v4n  4             default                 
     grp-f4rpy  0             web servers             
     grp-ncapg  0             db servers              
    ---------------------------------------------------

So we move them into the appropriate groups:

    $ brightbox-groups move_servers -f grp-98v4n -t grp-f4rpy srv-13y2j srv-25adm 
    Moving 2 servers from server group grp-98v4n to server group grp-f4rpy
    
     id         server_count  name       
    --------------------------------------
     grp-98v4n  2             default    
     grp-f4rpy  2             web servers
    --------------------------------------
    
    $ brightbox-groups move_servers -f grp-98v4n -t grp-ncapg srv-uj1wm srv-5x0ct 
    Moving 2 servers from server group grp-98v4n to server group grp-ncapg
    
     id         server_count  name      
    -------------------------------------
     grp-98v4n  0             default   
     grp-ncapg  2             db servers
    -------------------------------------

So now we have two servers in each group, and no servers in the default group. As soon as the `move_servers` command completes, the firewall rules take effect.  At this point might notice that we did not enable ssh access as we agreed (though the firewall is stateful, so any currently connected ssh sessions will continue to work until they close normally).

### Setting up SSH access

So we need to add a new rule allowing connections from our home Internet connection to all four servers. We could add the rule to both policies, but instead let's create a new group and associated policy especially for remote admin access.

So we create a new group called `ssh servers`:

    $ brightbox-groups create -n "ssh servers"
    
    Creating a new server group
    
     id         server_count  name               
    ----------------------------------------------
     grp-lqaky  0             ssh servers
    ----------------------------------------------

Then we create a new policy and apply it to the group:

    $ brightbox-firewall-policies create -n "remote admin access"
    
     id         server_group  name               
    ----------------------------------------------
     fwp-ekjbx                remote admin access
    ----------------------------------------------
    
    $ brightbox-firewall-policies apply fwp-ekjbx grp-lqaky
    
     id         server_group  name               
    ----------------------------------------------
     fwp-ekjbx  grp-lqaky     remote admin access
    ----------------------------------------------

Then we create a rule allowing ssh access from our trusty home AOL dialup, with IP address `172.191.5.18`:

    $ brightbox-firewall-rules create --source=172.191.5.18 --protocol=tcp --dport=22 fwp-ekjbx
    
     id         protocol  source        sport  destination  dport  icmp_type
    -------------------------------------------------------------------------
     fwr-4h891  tcp       172.191.5.18  -      -            22     -        
    -------------------------------------------------------------------------

Now we need to add all the servers to this group, keeping them in their other group, so we use the `add_servers` command rather than `move_servers`:

    $ brightbox-groups add_servers grp-lqaky srv-13y2j srv-25adm srv-uj1wm srv-5x0ct
    
    Adding 4 servers to server group grp-lqaky
    
     id         server_count  name               
    ----------------------------------------------
     grp-lqaky  4             remote admin access
    ----------------------------------------------

So now we can see there are two servers in the web and db groups, and all four servers are in the `ssh servers` group:

    $ brightbox-groups list
    
     id         server_count  name                    
    ---------------------------------------------------
     grp-98v4n  0             default                 
     grp-f4rpy  2             web servers             
     grp-ncapg  2             db servers              
     grp-lqaky  4             ssh servers     
    ---------------------------------------------------

When the `add_servers` command completed the new firewall rule came into effect, allowing ssh access to all four servers (in addition to the HTTP and MySQL access we already configured of course).

### Summary

So here we created some groups, applied firewall polices to them and set up some firewall rules.

Remember that now we've set everything up, we can just put new servers in the appropriate groups to automatically give them the correct access.  Whenever our home IP address changes we can easily update the ssh access policy for all servers at once.

For more detailed information about the different aspects of the Cloud Firewall, see the [reference documentation](/reference/firewall/).

