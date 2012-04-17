---
layout: default
title: Cloud IP Port Translation
section: Guides
---

### Background

Each Cloud Server has a single network interface, and therefore a single private
"real" IPv4 address (`10.x.x.x`). So, whilst you can map multiple
[Cloud IPs](http://docs.brightbox.com/guides/cli/cloud-ips/) to one
Cloud Server, all traffic comes into the same single IPv4 address. This
makes hosting different web sites with different TLS/SSL certificates
on the same server difficult, since the web server can't distinguish between
the different Cloud IPs.

For example, if you map two Cloud IPs to a server listening on HTTPS port
`443`, both Cloud IPs will serve the same site with the same certificate.

![](/images/port-translators-none.png)

The new TLS/SSL
[Server Name Indication](http://en.wikipedia.org/wiki/Server_Name_Indication)
feature is designed to solve this kind of problem, but not all
browsers support it (for example, Internet Explorer on Windows XP).

### The Solution: Port Translation

Port Translation enables you to change the destination port of incoming
connections on a particular [Cloud IP](http://docs.brightbox.com/guides/cli/cloud-ips/).
This behaviour can be used to host multiple SSL sites on a single server or
load balancer.

For example, let's assume we need to host two TLS/SSL sites on our server, one for
`cats.com` and the other for `dogs.com`

We configure our Apache web server so that `cats.com` listens on port `443`
as usual:

    Listen 443
    
    <VirtualHost *:443>
      ServerName cats.com
      SSLEngine On
      SSLCertificateFile /etc/ssl/certs/cats.crt
      SSLCertificateKeyFile /etc/ssl/private/cats.key
      DocumentRoot /home/cats/public
    </VirtualHost>


Then we create our first Cloud IP as normal and map it to our server:
    
    $ brightbox-cloudips create -n "cats" 
    
     id         status    public_ip      destination  name
    -------------------------------------------------------------------------------
     cip-360ea  unmapped  109.107.37.80               cats (cip-109-107-37-80.g...
    -------------------------------------------------------------------------------
    
    $ brightbox-cloudips map cip-360ea srv-9igaa
    Mapping cip-360ea to interface int-zylp1 on srv-9igaa
    
     id         status  public_ip      destination  name                   
    -------------------------------------------------------------------------------
     cip-360ea  mapped  109.107.37.80  srv-9igaa    cats (cip-109-107-37-80.gb1...
    -------------------------------------------------------------------------------

If we update the dns for `cats.com` to point at this IP
then the `cats.com` site is now live.

Now we configure Apache so that `dogs.com` listens on a different
port, let's use `2443`

    Listen 2443
    
    <VirtualHost *:2443>
      ServerName dogs.com
      SSLEngine On
      SSLCertificateFile /etc/ssl/certs/dogs.crt
      SSLCertificateKeyFile /etc/ssl/private/dogs.key
      DocumentRoot /home/dogs/public
    </VirtualHost>

Now we create a second Cloud IP, but this time we specify a port
translation to translate tcp port `443` to `2443`:

    $ brightbox-cloudips create -n "dogs" --port-translators=443:2443:tcp
    
     id         status    public_ip       destination  name
    -------------------------------------------------------------------------------
     cip-dnx8z  unmapped  109.107.37.228               dogs (cip-109-107-37-228...
    -------------------------------------------------------------------------------

And then map it to the server as normal:

    $ brightbox-cloudips map cip-dnx8z srv-9igaa
    Mapping cip-dnx8z to interface int-zylp1 on srv-9igaa
    
     id         status  public_ip       destination  name                  
    -------------------------------------------------------------------------------
     cip-dnx8z  mapped  109.107.37.228  srv-9igaa    dogs (cip-109-107-37-228.g...
    -------------------------------------------------------------------------------

![](/images/port-translators-2443.png)

Now if we update the DNS for `dogs.com` to point at this
second IP, then `dogs.com` is live too!

You can view the port translators for a particular Cloud IP using the 
`brightbox-cloudips show` command:

    $ brightbox-cloudips show cip-dnx8z
    
                  id: cip-dnx8z
                name: dogs
              status: mapped
           public_ip: 109.107.37.228
         reverse_dns: cip-109-107-37-228.gb1.brightbox.com
         destination: srv-9igaa
        interface_id: int-zylp1
    port_translators: 443:2443:tcp

You can define multiple translators per Cloud IP by comma separating them,
and you can, of course, change or remove them at any time using the
`brightbox-cloudips update` command.

You can translate UDP ports as well as TCP ports, so you can run
things like multiple DNS services on the same server too.

You can learn more about Cloud IPs in the
[Cloud IP guide](/guides/cli/cloud-ips) or in the
[reference page](/reference/cloud-ips) (which also has
[more details about port translation](/reference/cloud-ips/#port_translation)).
