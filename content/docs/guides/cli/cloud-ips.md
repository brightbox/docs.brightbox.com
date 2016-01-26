---
layout: default
title: Cloud IPs
section: CLI
---

[Cloud IPs](/docs/reference/cloud-ips/) are publicly accessible IPv4 addresses
that can be moved instantly between [servers](/docs/reference/cloud-servers/),
[load balancers](/docs/reference/load-balancers/) and
[Cloud SQL](/docs/reference/cloud-sql/) instances in Brightbox Cloud. They
belong to an account until they are destroyed. Once created, they can be mapped
to any server belonging to the same account.

### Creating a Cloud IP

You create Cloud IPs using the `brightbox cloudips` CLI command:

    #!shell
    $ brightbox cloudips create
    
     id         status    public_ip       server_id  interface_id  reverse_dns                            
    -------------------------------------------------------------------------------------------------------
     cip-1um8s  unmapped  109.107.35.140                           cip-109-107-35-140.gb1.brightbox.com
    -------------------------------------------------------------------------------------------------------

### Mapping a Cloud IP to a server

Find the id of the Cloud IP you want to map and the id of the server you want to map it to:

    #!shell
    $ brightbox cloudips list
    
     id         status    public_ip       server_id  interface_id  reverse_dns                            
    -------------------------------------------------------------------------------------------------------
     cip-1um8s  unmapped  109.107.35.140                           cip-109-107-35-140.gb1.brightbox.com
    -------------------------------------------------------------------------------------------------------
    
    $ brightbox servers list
    
     id         status    type    zone   created_on  image_id   cloud_ips       name           
    --------------------------------------------------------------------------------------------
     srv-zx1hd  active    nano    gb1-b  2010-11-05  img-hm6oj                  my first server
     srv-9puly  active    nano    gb1-a  2010-11-05  img-hm6oj                  my other server
    --------------------------------------------------------------------------------------------

And then simply map the IP to the server, using the `brightbox cloudips map` command:

    #!shell
    $ brightbox cloudips map cip-1um8s srv-zx1hd
    Mapping cip-1um8s to interface int-x4kve on srv-zx1hd
    
     id         status  public_ip       server_id  interface_id  reverse_dns                            
    -----------------------------------------------------------------------------------------------------
     cip-1um8s  mapped  109.107.35.140  srv-zx1hd  int-x4kve     cip-109-107-35-140.gb1.brightbox.com
    -----------------------------------------------------------------------------------------------------

You can now see that the IP mapping shows up in the server list too:

    #!shell
    $ brightbox servers list
    
     id         status    type    zone   created_on  image_id   cloud_ips       name           
    --------------------------------------------------------------------------------------------
     srv-zx1hd  active    nano    gb1-b  2010-11-05  img-hm6oj  109.107.35.140  my first server
     srv-9puly  active    nano    gb1-a  2010-11-05  img-hm6oj                  my other server
    --------------------------------------------------------------------------------------------

### DNS records

For your convenience, a DNS record is automatically created for Cloud IP
mappings. Whilst mappings are instantaneous, the DNS updates can take time to
propagate due to caching. It is usually updated within two minutes.

    #!shell
    $ host public.srv-zx1hd.gb1.brightbox.com
    public.srv-zx1hd.gb1.brightbox.com has address 109.107.35.140

And the Cloud IP itself has its own wildcard record too:

    #!shell
    $ host whatever.cip-1um8s.gb1.brightbox.com
    whatever.cip-1um8s.gb1.brightbox.com has address 109.107.35.140

### Remapping an IP

You can unmap the IP from one server and map it to another in one command with the `-u` option:

    #!shell
    $ brightbox cloudips map -u cip-1um8s srv-9puly
    Unmapping ip cip-1um8s
    Mapping cip-1um8s to interface int-3yqv6 on srv-9puly
    
     id         status  public_ip       server_id  interface_id  reverse_dns                            
    -----------------------------------------------------------------------------------------------------
     cip-1um8s  mapped  109.107.35.140  srv-9puly  int-3yqv6     cip-109-107-35-140.gb1.brightbox.com
    -----------------------------------------------------------------------------------------------------

### Unmap an IP

Unmapping an IP removes it from a server, but leaves it belonging to the account for future use:

    #!shell
    $ brightbox cloudips unmap cip-1um8s 
    Unmapping cloud ip cip-1um8s
    
     id         status    public_ip       server_id  interface_id  reverse_dns                            
    -------------------------------------------------------------------------------------------------------
     cip-1um8s  unmapped  109.107.35.140                           cip-109-107-35-140.gb1.brightbox.com
     -------------------------------------------------------------------------------------------------------

### Destroying an IP

When you're done with a Cloud IP, you can destroy it and it it will be removed
from your account and billing will stop for it:

    #!shell
    $ brightbox cloudips destroy cip-1um8s
    Destroying Cloud IP cip-1um8s

### Would you like to know more?

Here you created, mapped, remapped and unmapped a Cloud IP.

You might want to learn about [zones](/docs/reference/glossary/#zone) or learn
how to [create a snapshot](/docs/guides/cli/create-a-snapshot/)
