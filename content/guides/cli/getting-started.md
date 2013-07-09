---
layout: default
title: Getting Started with the CLI
section: CLI
---

We have a lovely [browser-based GUI](/guides/manager/) for
managing your Brightbox Cloud resources, but sometimes the power of a
command line interface is desired.

You can interact with Brightbox Cloud using our our command line
interface tool, which uses our API. This guide will take you from
creating a Brightbox Cloud Account to logging into your first Cloud
Server via SSH.

### Create an Account and API Client

Firstly,
[sign up for a Brightbox Cloud Account](/guides/getting-started/signup/)
using [Brightbox Manager](https://manage.brightbox.com/signup).

Once you've signed up, you now need to
[create an API Client](/guides/manager/api-clients/) which you'll use
to configure the CLI below. An API Client is simply a pair of access
credentials for accessing the API, consisting of a client identifier
(like `cli-xxxxx`) and a secret.

### Initial setup

#### Installation

Now that you have an account and an API Client, you'll need to
[install the cli software](/guides/cli/installation/). Go do that and
come back here. I'll wait for you.

#### Configuration

You can now configure the CLI with the credentials for the API client
you created.

To configure the cli with these credentials, run the following
command:

    $ brightbox-config client_add cli-xxxxx thesecretstring
		
    Using config file /home/john/.brightbox/config
    Creating new api client config cli-xxxxx

#### Initial test

You should be able to retrieve details of your user now. Note your id
as you'll need it in a moment:

    $ brightbox-users list
    
     id         name        email_address         accounts
    -------------------------------------------------------
     usr-xxxxx  John Doe    john@example.com      1       
    -------------------------------------------------------

#### Configuring your ssh key

You need to upload your public ssh key so that you can log into newly
created servers:

    $ brightbox-users update -f my-ssh-key.pub usr-xxxxx
               id: usr-xxxxx
             name: John Doe
    email_address: john@example.com
         accounts: acc-xxxxx
          ssh_key: ssh-dss AAAAB3....

### Building your first server

#### Choose an image

First, let's choose an operating system
[Image](/reference/server-images/) to use:

    $ brightbox-images list

     id         owner      type      created_on  status   size   name                                                     
    -----------------------------------------------------------------------------------------------------------------------
     img-hy0lf  brightbox  official  2013-05-10  public   0      Blank Disk Image (i686)                                  
     img-t3xyp  brightbox  official  2013-05-10  public   0      Blank Disk Image (x86_64)                                
     img-adtke  brightbox  official  2011-07-20  public   0      Blank disk image (compat) (i686)                         
     img-ztdma  brightbox  official  2011-07-20  public   0      Blank disk image (compat) (x86_64)                       
     img-itn4a  brightbox  official  2013-05-02  public   1      Brightbox Bootstaller (i686)                             
     img-6xgf1  brightbox  official  2013-05-02  public   1      Brightbox Bootstaller (x86_64)                           
     img-2vn9s  brightbox  official  2013-05-10  public   5222   CentOS 5.9 server (x86_64)                               
     img-h9zix  brightbox  official  2013-05-10  public   5120   CentOS 6.4 server (i686)                                 
     img-6rdtr  brightbox  official  2013-05-10  public   5120   CentOS 6.4 server (x86_64)                               
     img-k3399  brightbox  official  2013-05-10  public   5125   Fedora 17 server (i686)                                  
     img-zhroq  brightbox  official  2013-05-10  public   5125   Fedora 17 server (x86_64)                                
     img-1okdf  brightbox  official  2010-11-19  public   20480  FreeBSD 8.1 minimal (i686)                               
     img-aoubd  brightbox  official  2010-11-19  public   20480  FreeBSD 8.1 minimal (x86_64)                             
     img-zwg4b  brightbox  official  2013-05-10  public   5222   Scientific Linux 5.9 server (x86_64)                     
     img-vgetc  brightbox  official  2013-05-10  public   5120   Scientific Linux 6.4 server (i686)                       
     img-n4f5o  brightbox  official  2013-05-10  public   5120   Scientific Linux 6.4 server (x86_64)                     
     img-a1yu3  brightbox  official  2013-05-10  public   769    Ubuntu Lucid 10.04 LTS server (i686)                     
     img-gaaeo  brightbox  official  2013-05-10  public   1025   Ubuntu Lucid 10.04 LTS server (x86_64)                   
     img-hnigl  brightbox  official  2012-03-14  public   20480  Windows 2008 Server R2 (x86_64)                          
     img-ovv3h  brightbox  official  2013-05-10  public   2048   ubuntu-precise-12.04-amd64-server (x86_64)               
     img-sougg  brightbox  official  2013-05-10  public   2048   ubuntu-precise-12.04-i386-server (i686)                  
     img-x9lfj  brightbox  official  2013-05-10  public   2048   ubuntu-quantal-12.10-amd64-server (x86_64)               
     img-t3dyq  brightbox  official  2013-05-10  public   2048   ubuntu-quantal-12.10-i386-server (i686)                  
     img-g8ia6  brightbox  official  2013-05-10  public   2048   ubuntu-raring-13.04-amd64-server (x86_64)                
     img-u3ttt  brightbox  official  2013-05-10  public   2048   ubuntu-raring-13.04-i386-server (i686)                   
    -----------------------------------------------------------------------------------------------------------------------

Let's go with `ubuntu-precise-12.04-amd64-server`, which is has an
identifier of `img-ovv3h`. We can inspect the details of the image
using `brightbox-images show`. The `username` field shows that the
default account is named `ubuntu`.

    $ brightbox-images show img-ovv3h

                    id: img-ovv3h
                  type: official
                 owner: brightbox
            created_at: 2013-05-10T08:41Z
                status: public
                  arch: x86_64
                  name: ubuntu-precise-12.04-amd64-server (x86_64)
           description: ID: com.ubuntu.cloud:released:download/com.ubuntu.cloud:server:12.04:amd64/20130502
              username: ubuntu
          virtual_size: 2048
             disk_size: 241
                public: true
    compatibility_mode: false
              official: true
           ancestor_id: 
          licence_name:

#### Create the server

Now you can create a server using that image. Give it a name of `my
first server` so you can identify it easily later:

    $ brightbox-servers create -n "my first server" img-ovv3h
		
    Creating 1 'nano' (typ-4nssg) server with image ubuntu-precise-12.04-amd64-server (img-ovv3h)
    
     id         status    type  zone   created_on  image_id   cloud_ips  name           
    -------------------------------------------------------------------------------------
     srv-zx1hd  creating  nano  gb1-b  2013-06-21  img-ovv3h             my first server
    -------------------------------------------------------------------------------------

Note that the new server has been given the identifier `srv-zx1hd`.

If you wait a few moments and show the details of the new server, it
should have changed status from `creating` to `active`, which means
it has been built and has started up:

    $ brightbox-servers show srv-zx1hd
    		
                 id: srv-zx1hd
             status: active
               name: my first server
         created_at: 2013-06-21T00:24
         deleted_at: 
               zone: gb1-a
               type: typ-4nssg
          type_name: Brightbox Nano Instance
        type_handle: nano
                ram: 512
              cores: 2
               disk: 10240
              image: img-ovv3h
         image_name: ubuntu-precise-12.04-amd64-server
        private_ips: 10.146.19.166
          cloud_ips: 
       ipv6_address: 2a02:1348:14c:4f3:24:19ff:fef0:13ce
       cloud_ip_ids: 
           hostname: srv-zk1hd.gb1.brightbox.com
    public_hostname: 
      ipv6_hostname: ipv6.srv-zk1hd.gb1.brightbox.com
          snapshots: 
      server_groups: grp-98v4n

			
#### Mapping a cloud IP

So now you have a server with a IPv6 address and a private IPv4
address.  You can reach it straight away if you have an IPv6 Internet
connection:

    $ ping6 ipv6.srv-zx1hd.gb1.brightbox.com
		
    PING ipv6.srv-zx1hd.gb1.brightbox.com(2a02:1348:14c:4f3:24:19ff:fef0:13ce) 56 data bytes
    64 bytes from 2a02:1348:14c:4f3:24:19ff:fef0:13ce: icmp_seq=1 ttl=54 time=13.8 ms
    
    --- ipv6.srv-qdhro.gb1.brightbox.com ping statistics ---
    1 packets transmitted, 1 received, 0% packet loss, time 0ms
    rtt min/avg/max/mdev = 13.876/13.876/13.876/0.000 ms

To give it a public IPv4 address, you need to map a
[Cloud IP](/reference/cloud-ips/) to it. Firstly, create a Cloud IP on
your account:

    $ brightbox-cloudips create

     id         status    public_ip      destination  reverse_dns                          name
    --------------------------------------------------------------------------------------------
     cip-360ea  unmapped  109.107.37.80               cip-109-107-37-80.gb1.brightbox.com      
    --------------------------------------------------------------------------------------------

Then map it to your server using the Cloud IP identifier and your
server identifier:

    $ brightbox-cloudips map cip-360ea srv-zx1hd
		
    Mapping cip-360ea to interface int-x4kve on srv-zx1hd


     id         status  public_ip      destination  reverse_dns                          name
    ------------------------------------------------------------------------------------------
     cip-360ea  mapped  109.107.37.80  srv-zx1hd    cip-109-107-37-80.gb1.brightbox.com      
    ------------------------------------------------------------------------------------------


Now you can log in via ssh using your ssh key. Remember, this image
uses the `ubuntu` account by default:

    $ ssh ubuntu@109.107.37.80
    Welcome to Ubuntu 12.04.2 LTS (GNU/Linux 3.2.0-41-virtual)
    
    ubuntu@srv-zx1hd:~$ uptime
     13:02:07 up  0:01,  1 user,  load average: 0.04, 0.01, 0.00
		 
For convenience, there is also a dns entry for the first Cloud IP
mapped to a server:

    $ host public.srv-zx1hd.gb1.brightbox.com
		
    public.srv-zx1hd.gb1.brightbox.com has address 109.107.37.80

### Would you like to know more?

Here you installed and configured the Command Line Interface tool,
created an Ubuntu server, mapped a Cloud IP to it and connected in
using ssh.

You might want to learn more about
[Cloud IPs](/guides/cli/cloud-ips/),
[discover zones](/reference/glossary/#zone) or learn how to
[Create a snapshot](/guides/cli/create-a-snapshot/).

You might also want to learn a bit about the default
[firewall policy](/guides/cli/firewall/), and how to change it.

<small>Join the Mobile Infantry and save the Galaxy. Service
guarantees citizenship.</small>
