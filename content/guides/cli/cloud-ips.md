---
layout: default
title: Cloud IPs
---

Cloud IPs are publicly accessible IP addresses that can be moved
instantly between servers in the Brightbox Cloud. They belong to an
account until they are destroyed. Once created, they can be mapped to
any server belonging to the same account.


### Creating a cloud IP
You create cloud ips using the `brightbox-cloudips` Command Line Interface tool:

    $ brightbox-cloudips create
    
     id         status    public_ip       server_id  interface_id  reverse_dns                            
    -------------------------------------------------------------------------------------------------------
     cip-1um8s  unmapped  109.107.35.140                           cip-109-107-35-140.gb1.brightbox.com
    -------------------------------------------------------------------------------------------------------

### Mapping a cloud IP to a server

Find the id of the cloud ip you want to map and the id of the server you want to map it to:

    $ brightbox-cloudips list
    
     id         status    public_ip       server_id  interface_id  reverse_dns                            
    -------------------------------------------------------------------------------------------------------
     cip-1um8s  unmapped  109.107.35.140                           cip-109-107-35-140.gb1.brightbox.com
    -------------------------------------------------------------------------------------------------------
    
    $ brightbox-servers list
    
     id         status    type    zone   created_on  image_id   cloud_ips       name           
    --------------------------------------------------------------------------------------------
     srv-zx1hd  active    nano    gb1-b  2010-11-05  img-hm6oj                  my first server
     srv-9puly  active    nano    gb1-a  2010-11-05  img-hm6oj                  my other server
    --------------------------------------------------------------------------------------------

And then simply map the ip to the server, using the `brightbox-cloudips map` command:

    $ brightbox-cloudips map cip-1um8s srv-zx1hd
    Mapping cip-1um8s to interface int-x4kve on srv-zx1hd
    
     id         status  public_ip       server_id  interface_id  reverse_dns                            
    -----------------------------------------------------------------------------------------------------
     cip-1um8s  mapped  109.107.35.140  srv-zx1hd  int-x4kve     cip-109-107-35-140.gb1.brightbox.com
    -----------------------------------------------------------------------------------------------------

You can now see that the IP mapping shows up in the server list too:

    $ brightbox-servers list
    
     id         status    type    zone   created_on  image_id   cloud_ips       name           
    --------------------------------------------------------------------------------------------
     srv-zx1hd  active    nano    gb1-b  2010-11-05  img-hm6oj  109.107.35.140  my first server
     srv-9puly  active    nano    gb1-a  2010-11-05  img-hm6oj                  my other server
    --------------------------------------------------------------------------------------------

### DNS records

For your convenience, a dns record is automatically created for cloud ip mappings. Whilst mappings are instantaneous, the dns updates can take time to propagate due to caching. It is usually updated within two minutes.

    $ host public.srv-zx1hd.gb1.brightbox.com
    public.srv-zx1hd.gb1.brightbox.com has address 109.107.35.140

### Remapping an IP

You can unmap the ip from one server and map it to another in one command with the `-u` option:

    $ brightbox-cloudips map -u cip-1um8s srv-9puly
    Unmapping ip cip-1um8s
    Mapping cip-1um8s to interface int-3yqv6 on srv-9puly
    
     id         status  public_ip       server_id  interface_id  reverse_dns                            
    -----------------------------------------------------------------------------------------------------
     cip-1um8s  mapped  109.107.35.140  srv-9puly  int-3yqv6     cip-109-107-35-140.gb1.brightbox.com
    -----------------------------------------------------------------------------------------------------

### Unmap an IP

Unmapping an IP removes it from a server, but leaves it belonging to the account for future remappings:

    $ brightbox-cloudips unmap cip-1um8s 
    Unmapping cloud ip cip-1um8s
    
     id         status    public_ip       server_id  interface_id  reverse_dns                            
    -------------------------------------------------------------------------------------------------------
     cip-1um8s  unmapped  109.107.35.140                           cip-109-107-35-140.gb1.brightbox.com
    -------------------------------------------------------------------------------------------------------

### Would you like to know more?

Here you created, mapped, remapped and unmapped a cloud IP.

You might want to learn about zones or learn how to Create a snapshot.
