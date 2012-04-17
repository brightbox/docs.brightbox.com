---
layout: default
title: Port Translators
section: Guides
---

### The problem

Although you can map multiple
[Cloud IPs](http://docs.brightbox.com/guides/cli/cloud-ips/) to a
Cloud Server, the server itself can only have one real IPv4
address. So for example, if you map two Cloud IPs to a server
listening on HTTPS port 443, both Cloud IPs will serve the same site
with the same SSL certificate.

![](/images/port-translators-none.png)

This makes hosting different web sites with different SSL certificates
on the same server difficult.

You could use SSL's new
[Server Name Indication](http://en.wikipedia.org/wiki/Server_Name_Indication)
feature to achieve this, but it is still not supported in all browsers
(in particular, no version of Internet Explorer on Windows XP supports
it).

### The solution: Port Translators

Port Translators allow you to change the destination port of incoming
connections on a particular Cloud IP. This behaviour can be used to
host multiple SSL sites on a single server or load balancer.

So, let's assume we need to host two SSL sites on our server, one for
<code>cats.com</code> and the other for <code>dogs.com</code>

We configure our Apache web server so that cats.com listens on port
<code>443</code> as usual:

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

If we update the dns for <code>cats.com</code> to point at this IP
then the <code>cats.com</code> site is now live.

Now we configure Apache so that <code>dogs.com</code> listens on another port,
let's use <code>2443</code>

    Listen 2443
    
    <VirtualHost *:2443>
      ServerName dogs.com
      SSLEngine On
      SSLCertificateFile /etc/ssl/certs/dogs.crt
      SSLCertificateKeyFile /etc/ssl/private/dogs.key
      DocumentRoot /home/dogs/public
    </VirtualHost>

Now we create a second Cloud IP, but this time we specify a port
translator to translate port <code>443</code> to <code>2443</code>:

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

Now if we update the dns for <code>dogs.com</code> to point at this
second IP and then <code>dogs.com</code> is live too!

Port translators are associated with the Cloud IP, so when you move
the IP to a new server the translators move with it.  You can see them
listed using the <code>brightbox-cloudips show</code> command:

    $ brightbox-cloudips show cip-dnx8z
    
                  id: cip-dnx8z
                name: dogs
              status: mapped
           public_ip: 109.107.37.228
         reverse_dns: cip-109-107-37-228.gb1.brightbox.com
         destination: srv-9igaa
        interface_id: int-zylp1
    port_translators: 443:2443:tcp

You can define multiple translators per IP by comma separating them,
and you can of course change or remove them at any time using the
<code>brightbox-cloudips update</code> command.

And you can translate UDP ports as well as TCP ports, so you can run
things like multiple dns services on the same server too.

You can learn more about Cloud IPs in the
[Cloud IP guide](/guides/cli/cloud-ips) or in the
[reference page](/reference/cloud-ips) (which also has
[more details about port translators](/reference/cloud-ips/#port_translators)).
