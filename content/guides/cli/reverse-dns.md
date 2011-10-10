---
layout: default
title: Reverse DNS
section: Guides
---

Brightbox [Cloud IPs](/reference/cloud-ips/) have a default generic reverse dns entry. For example:

    $ host 109.107.38.125
    125.38.107.109.in-addr.arpa domain name pointer cip-109-107-38-125.gb1.brightbox.com.

And the forward dns entry works too, as you'd expect:

    $ host cip-109-107-38-125.gb1.brightbox.com
    cip-109-107-38-125.gb1.brightbox.com has address 109.107.38.125
		
You can customize the reverse dns very easily using the cli (since version 0.14). Firstly you need to set up your normal forward mapping using your usual dns provider.  In this case I'm setting up reverse dns for my mail server, so I'll use `mailserver.example.com`.  So I'll confirm that is working correctly:

    $ host mailserver.example.com
    mailserver.example.com has address 109.107.38.125

It's important that you set up the forward mapping first, Brightbox Cloud will reject attempts to set up a reverse dns entry if your forward dns entry is not valid first.

Showing the help for the `brightbox-cloudips` command reveals some dns options:

    $ brightbox-cloudips help update
    update [command options] cloudip-id
        update Cloud IPs
    
    Command Options:
        --delete-reverse-dns  - Delete the reverse dns for this cloud ip
        -r, --reverse-dns=arg - Set reverse DNS for this cloud ip

So now I need to find the identifier of this Cloud IP:

    $ brightbox-cloudips list | grep 109.107.38.125
     id         status    public_ip       destination  reverse_dns                         
    ----------------------------------------------------------------------------------------
     cip-wh8d7  unmapped  109.107.38.125               cip-109-107-38-125.gb1.brightbox.com

My identifier is `cip-wh8d7`. I can now update the reverse dns:

    $ brightbox-cloudips update --reverse-dns=mailserver.example.com cip-wh8d7		
		
     id         status    public_ip       destination  reverse_dns     
    --------------------------------------------------------------------------
     cip-wh8d7  unmapped  109.107.38.125               mailserver.example.com
    --------------------------------------------------------------------------
		
And the dns should be configured instantly:

    $ host 109.107.38.125 
    125.38.107.109.in-addr.arpa domain name pointer mailserver.example.com.
		
### Invalid reverse DNS

If the forward DNS mapping is later removed, or changed to point at a different address, the reverse DNS mapping will eventually automatically switch back to the default. See the [reverse dns reference docs](/reference/dns#reverse_dns) for more information.

### Removing custom reverse DNS

It's simple to manually remove the custom dns and go back to the default:

    $ brightbox-cloudips update --delete-reverse-dns cip-wh8d7
    
     id         status    public_ip       destination  reverse_dns                         
    ----------------------------------------------------------------------------------------
     cip-wh8d7  unmapped  109.107.38.125               cip-109-107-38-125.gb1.brightbox.com
    ----------------------------------------------------------------------------------------

