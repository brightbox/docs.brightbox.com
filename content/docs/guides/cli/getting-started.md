---
layout: default
title: Getting Started
section: CLI
---

We have a lovely [browser-based GUI](/docs/guides/manager/) for
managing your Brightbox Cloud resources, but sometimes the power of a
command line interface is required.

You can interact with Brightbox Cloud using our our command line
interface tool, which uses our API. This guide will take you from
creating a Brightbox Cloud Account to logging into your first Cloud
Server via SSH.

### Create an Account and OAuth Application

Firstly,
[sign up for a Brightbox Cloud Account](/docs/guides/getting-started/signup/)
using [Brightbox Manager](https://manage.brightbox.com/signup).

### Install the CLI

Now that you have an account, you'll need to
[install our CLI software](/docs/guides/cli/installation/). Go do that and come
back here. I'll wait for you.

### Login with the CLI

Now you have the CLI installed, use it to login with your email and password:

    #!shell
    $ brightbox login john@example.com
    Enter your password : 
    The default account of acc-12345 has been selected

Notice that your account has automatically been selected as the default. If you
only have one account then don't worry. However, if you have multiple accounts
or are a [collaborator](/docs/reference/collaboration/) on another user's
account, you might want to select a specific account as your default using using
the `--default-account` option to the `login` command.

#### Initial test

You should now be able to retrieve details of your user. Note your id as you'll
need it in a moment to set an SSH key:

    #!shell
    $ brightbox users list
    
     id         name        email_address         accounts
    -------------------------------------------------------
     usr-xxxxx  John Doe    john@example.com      1       
    -------------------------------------------------------

#### Configuring your SSH key

If you didn't provide your
[public SSH](https://help.ubuntu.com/community/SSH/OpenSSH/Keys) key when you
signed up, you need to do that now so that you can log into newly created
servers.

    #!shell
    $ brightbox users update -f /home/john/.ssh/id_rsa.pub usr-xxxxx
               id: usr-xxxxx
             name: John Doe
    email_address: john@example.com
         accounts: acc-12345
          ssh_key: ssh-dss AAAAB3....

### Building your first server

#### Choose an image

First, let's choose an operating system
[Image](/docs/reference/server-images/) to use:

    #!shell
    $ brightbox images

     id         owner      type      created_on  status  size   name                                                     
    --------------------------------------------------------------------------------------------------------------------------
     img-jxfq8  brightbox  official  2014-11-13  public  5222   CentOS 5.11 server (x86_64)                              
     img-p238z  brightbox  official  2015-03-20  public  8192   CentOS-6-x86_64-server (x86_64)                          
     img-6o34u  brightbox  official  2015-10-06  public  2183   CentOS-7-x86_64-atomic (x86_64)                          
     img-2s6s9  brightbox  official  2015-10-09  public  8192   CentOS-7-x86_64-server (x86_64)                          
     img-bkqh0  brightbox  official  2015-09-30  public  8694   CoreOS 766.4.0 (x86_64)                                  
     img-j9r4f  brightbox  official  2015-01-20  public  3072   Fedora-21-i686-server (i686)                             
     img-65b8s  brightbox  official  2015-01-20  public  3072   Fedora-21-x86_64-server (x86_64)                         
     img-1vvl0  brightbox  official  2015-05-27  public  3072   Fedora-22-i686-server (i686)                             
     img-m7tzp  brightbox  official  2015-05-27  public  3072   Fedora-22-x86_64-server (x86_64)                         
     img-gem97  brightbox  official  2014-12-17  public  20480  FreeBSD-10.1-RELEASE-amd64 (x86_64)                      
     img-sttkx  brightbox  official  2014-12-17  public  20480  FreeBSD-10.1-RELEASE-i386 (i686)                         
     img-y8jpj  brightbox  official  2014-12-18  public  20480  FreeBSD-9.3-RELEASE-amd64 (x86_64)                       
     img-tgfca  brightbox  official  2014-12-18  public  20480  FreeBSD-9.3-RELEASE-i386 (i686)                          
     img-ixqw1  brightbox  official  2014-11-13  public  5120   Scientific Linux 6.6 server (i686)                       
     img-sc5z7  brightbox  official  2014-11-13  public  5120   Scientific Linux 6.6 server (x86_64)                     
     img-65mjf  brightbox  official  2015-10-06  public  2048   debian-testing-amd64-server (x86_64)                     
     img-fumyk  brightbox  official  2015-10-24  public  3720   ubuntu-1504-snappy-core-amd64-edge (x86_64)              
     img-kqooe  brightbox  official  2015-10-24  public  3720   ubuntu-1504-snappy-core-amd64-stable (x86_64)            
     img-19gmq  brightbox  official  2015-10-21  public  2252   ubuntu-precise-12.04-amd64-server (x86_64)               
     img-4hjvk  brightbox  official  2015-10-21  public  2252   ubuntu-precise-12.04-i386-server (i686)                  
     img-laj3u  brightbox  official  2015-10-29  public  3720   ubuntu-rolling-snappy-core-amd64-edge (x86_64)           
     img-bbm1e  brightbox  official  2015-10-21  public  2252   ubuntu-trusty-14.04-amd64-server (x86_64)                
     img-gbndq  brightbox  official  2015-10-21  public  2252   ubuntu-trusty-14.04-amd64-server-uefi1 (x86_64)          
     img-qyku6  brightbox  official  2015-10-21  public  2252   ubuntu-trusty-14.04-i386-server (i686)                   
     img-ssavr  brightbox  official  2015-10-22  public  2252   ubuntu-vivid-15.04-amd64-server (x86_64)                 
     img-ieftk  brightbox  official  2015-10-22  public  2252   ubuntu-vivid-15.04-amd64-server-uefi1 (x86_64)           
     img-huj47  brightbox  official  2015-10-22  public  2252   ubuntu-vivid-15.04-i386-server (i686)                    
     img-8k8vn  brightbox  official  2015-04-22  public  9299   ubuntu-vivid-snappy-core-amd64-edge (x86_64)             
     img-dqq3t  brightbox  official  2015-10-27  public  2252   ubuntu-wily-15.10-amd64-server (x86_64)                  
     img-rh99j  brightbox  official  2015-10-27  public  2252   ubuntu-wily-15.10-amd64-server-uefi1 (x86_64)            
     img-3o0e6  brightbox  official  2015-10-27  public  2252   ubuntu-wily-15.10-i386-server (i686)                     
    --------------------------------------------------------------------------------------------------------------------------

Let's use `ubuntu-precise-12.04-amd64-server`, which is has an
identifier of `img-19gmq`. We can inspect the details of the image
using `brightbox images show`. The `username` field shows that the
default account is named `ubuntu`.

    #!shell
    $ brightbox images show img-19gmq

                    id: img-19gmq
                  type: official
                 owner: brightbox
            created_at: 2015-10-29T08:41Z
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

    #!shell
    $ brightbox servers create -n "my first server" img-19gmq
    
    Creating a 1gb.ssd (typ-w0hf9) server with image ubuntu-precise-12.04-amd64-server (img-19gmq)
    
     id         status    type     zone   created_on  image_id   cloud_ips  name           
    ----------------------------------------------------------------------------------------
     srv-zx1hd  creating  1gb.ssd  gb1-b  2015-10-29  img-19gmq             my first server
    ----------------------------------------------------------------------------------------

Note that the new server has been given the identifier `srv-zx1hd`.

If you wait a few moments and show the details of the new server, it
should have changed status from `creating` to `active`, which means
it has been built and has started up:

    #!shell
    $ brightbox servers show srv-zx1hd
        
                 id: srv-zx1hd
             status: active
             locked: false
               name: my first server
         created_at: 2015-10-29T00:24
         deleted_at: 
               zone: gb1-a
               type: typ-w0hf9
          type_name: SSD 1GB
        type_handle: nano
                ram: 1024
              cores: 1
               disk: 30720
              image: img-19gmq
         image_name: ubuntu-precise-12.04-amd64-server
        private_ips: 10.146.19.166
          cloud_ips: 
       ipv6_address: 2a02:1348:14c:4f3:24:19ff:fef0:13ce
       cloud_ip_ids:
           hostname: srv-zk1hd
               fqdn: srv-zk1hd.gb1.brightbox.com
    public_hostname: 
      ipv6_hostname: ipv6.srv-zk1hd.gb1.brightbox.com
          snapshots: 
      server_groups: grp-98v4n

      
#### Mapping a Cloud IP

So now you have a server with a IPv6 address and a private IPv4 address. You can
reach it straight away if you have an IPv6 Internet connection:

    #!shell
    $ ping6 ipv6.srv-zx1hd.gb1.brightbox.com
    
    PING ipv6.srv-zx1hd.gb1.brightbox.com(2a02:1348:14c:4f3:24:19ff:fef0:13ce) 56 data bytes
    64 bytes from 2a02:1348:14c:4f3:24:19ff:fef0:13ce: icmp_seq=1 ttl=54 time=13.8 ms
    
    --- ipv6.srv-qdhro.gb1.brightbox.com ping statistics ---
    1 packets transmitted, 1 received, 0% packet loss, time 0ms
    rtt min/avg/max/mdev = 13.876/13.876/13.876/0.000 ms

To give it a public IPv4 address, you need to map a
[Cloud IP](/docs/reference/cloud-ips/) to it. Firstly, create a Cloud IP on your
account:

    #!shell
    $ brightbox cloudips create

     id         status    public_ip      destination  reverse_dns                          name
    --------------------------------------------------------------------------------------------
     cip-360ea  unmapped  109.107.37.80               cip-109-107-37-80.gb1.brightbox.com      
    --------------------------------------------------------------------------------------------

Then map it to your server using the Cloud IP identifier and your server
identifier:

    #!shell
    $ brightbox cloudips map cip-360ea srv-zx1hd
    
    Mapping cip-360ea to interface int-x4kve on srv-zx1hd


     id         status  public_ip      destination  reverse_dns                          name
    ------------------------------------------------------------------------------------------
     cip-360ea  mapped  109.107.37.80  srv-zx1hd    cip-109-107-37-80.gb1.brightbox.com      
    ------------------------------------------------------------------------------------------


Now you can log in via SSH using your ssh key. Remember, this image uses the
`ubuntu` account by default:

    #!shell
    $ ssh ubuntu@109.107.37.80
    Welcome to Ubuntu 12.04.2 LTS (GNU/Linux 3.2.0-41-virtual)
    
    ubuntu@srv-zx1hd:~$ uptime
     13:02:07 up  0:01,  1 user,  load average: 0.04, 0.01, 0.00
     
For convenience, there is also a DNS entry for the first Cloud IP mapped to a
server:

    #!shell
    $ host public.srv-zx1hd.gb1.brightbox.com
    
    public.srv-zx1hd.gb1.brightbox.com has address 109.107.37.80

### Would you like to know more?

Here you installed and configured the Command Line Interface tool,
created an Ubuntu server, mapped a Cloud IP to it and connected in
using ssh.

You might want to learn more about
[Cloud IPs](/docs/guides/cli/cloud-ips/),
[discover zones](/docs/reference/glossary/#zone) or learn how to
[Create a snapshot](/docs/guides/cli/create-a-snapshot/).

You'll also need to know about [server types](/docs/reference/server-types/) so
you can build servers with different specs. See the `brightbox types` command
for a list.

You might also want to learn a bit about the default
[firewall policy](/docs/guides/cli/firewall/), and how to change it.

If you want to automate use of the CLI you may want to look into authenticating
with an [API client](/docs/guides/cli/api-clients), rather than your user
credentials.

