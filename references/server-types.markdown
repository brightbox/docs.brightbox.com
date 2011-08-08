---
layout: default
title: Server Types
---

A server type is a certain spec of server, configuring ram size, cpu
cores and disk size.  You can specify the server type when creating a
new server.  If you don't specify one, the default `nano` type is
used.

Servers created with different server types are charged at different
hourly rates.

The `brightbox-types` command is used to browse the list of server
types:

    $ brightbox-types list
    
     id         name                       handle  ram   disk    cores  description
    --------------------------------------------------------------------------------
     typ-4nssg  Brightbox Nano Instance    nano    512   20480   2                 
     typ-iqisj  Brightbox Mini Instance    mini    1024  40960   4                 
     typ-urtky  Brightbox Small Instance   small   2048  81920   4                 
     typ-qdiwq  Brightbox Medium Instance  medium  4096  163840  8                 
     typ-mlbt7  Brightbox Large Instance   large   8192  327680  8                 
    --------------------------------------------------------------------------------

When creating a new server you can specify the server type using the
`id` or, more conveniently, the `handle`:

    $ brightbox-servers create -t small img-4gqhs
    
    Creating a small (typ-urtky) server with image Ubuntu Lucid 10.04 server (img-4gqhs)
    
     id         status    type   zone   created_on  image_id   cloud_ip_ids  name
    ------------------------------------------------------------------------------
     srv-r54ev  creating  small  gb1-a  2011-08-08  img-4gqhs                    
    ------------------------------------------------------------------------------

You cannot resize an existing server to other types in-place. Instead,
you should snapshot your current server and build a new one with the
new type.  You must ensure the disk size of the new server is large
enough to fit the snapshot.
