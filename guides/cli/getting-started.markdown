---
layout: default
title: Getting Started
---

All interaction with the Brightbox Cloud is currently through our
command line interface (which uses our API). So you'll need some API
client credentials and the cli software.

Your API client credentials should be composed of a client identifier
and a secret. To get these you'll need to
[request a beta account](http://beta.brightbox.com/).

## Initial setup

### Installation

Firstly, you'll need to
[install the cli software](/guides/cli/installation.html). Go do that and come back here.

### Configuration

You should have received some API client credentials from us, which
should consist of a client id and a secret. To configure the cli with
these credentials, run the following command:

    $ brightbox-config client_add cli-xxxxx thesecretstring
    Using config file /home/john/.brightbox/config
    Creating new api client config cli-xxxxx

### Initial test

You should be able to retrieve details of your user now. Note your id as you'll need it in a moment:

    $ brightbox-users list
    
     id         name        email_address         accounts
    -------------------------------------------------------
     usr-xxxxx  John Doe    john@example.com      1       
    -------------------------------------------------------

### Configuring your ssh key

You need to upload your public ssh key so that you can log into newly created servers:

    $ brightbox-users update -f my-ssh-key.pub usr-xxxxx
               id: usr-xxxxx
             name: John Doe
    email_address: john@example.com
         accounts: acc-xxxxx
          ssh_key: ssh-dss AAAAB3....

## Building your first server

### Choose an image

First, let's choose an image to use:

    $ brightbox-images list 
    
     id         owner      type      created_on  status   size   name                                       
    -----------------------------------------------------------------------------------------------------
     img-3rb1e  brightbox  official  2011-04-19  public   0      Blank disk image (i686)                    
     img-715uq  brightbox  official  2011-04-19  public   0      Blank disk image (x86_64)                  
     img-99q79  brightbox  official  2010-10-02  public   10244  CentOS 5.5 server (i686)                   
     img-pnqnc  brightbox  official  2010-10-03  public   10240  CentOS 5.5 server (x86_64)                 
     img-qjuex  brightbox  official  2010-10-14  public   10244  Fedora 14 Beta Base (i686)                 
     img-vyeeg  brightbox  official  2010-10-15  public   10244  Fedora 14 Beta Base (x86_64)               
     img-1okdf  brightbox  official  2010-11-19  public   20480  FreeBSD 8.1 minimal (i686)                 
     img-aoubd  brightbox  official  2010-11-19  public   20480  FreeBSD 8.1 minimal (x86_64)               
     img-hvqt1  brightbox  official  2011-04-18  public   2049   Ubuntu Hardy 8.04 server (i686)            
     img-687qk  brightbox  official  2011-04-18  public   2049   Ubuntu Hardy 8.04 server (x86_64)          
     img-4gqhs  brightbox  official  2011-05-09  public   1409   Ubuntu Lucid 10.04 server (i686)           
     img-3ikco  brightbox  official  2011-05-09  public   1409   Ubuntu Lucid 10.04 server (x86_64)         
     img-7i0fl  brightbox  official  2011-05-09  public   1409   Ubuntu Maverick 10.10 server (i686)        
     img-cq4kz  brightbox  official  2011-05-09  public   1409   Ubuntu Maverick 10.10 server (x86_64)      
     img-ieh3b  brightbox  official  2011-05-09  public   1409   Ubuntu Natty 11.04 server (i686)           
     img-7p3wu  brightbox  official  2011-05-09  public   1409   Ubuntu Natty 11.04 server (x86_64)         
    -----------------------------------------------------------------------------------------------------

Let's go with i686 Ubuntu Lucid 10.04 server, which is has an id of
`img-4gqhs`. We'll get the description of it, which should have some
notes about how to access it once it's booted. This image says it has
an ubuntu user by default:

    $ brightbox-images show img-4gqhs
    
                    id: img-4gqhs
                  type: official
                 owner: brightbox
            created_at: 2011-05-09T14:35:20Z
                status: public
                  arch: i686
                  name: Ubuntu Lucid 10.04 server (i686)
           description: Expands root partition automatically. login: ubuntu using stored ssh key
          virtual_size: 1409
             disk_size: 542
    compatibility_mode: false
              official: true
           ancestor_id: 
					 

### Create the server

Now you can create a server using that image. Give it a name of "my
first server" so you can identify it easily later.

    $ brightbox-servers create -n "my first server" img-hm6oj
    Creating 1 'nano' (typ-4nssg) server with image Ubuntu Lucid 10.04 server (img-hm6oj)
    
     id         status    type  zone   created_on  image_id   cloud_ips  name           
    -------------------------------------------------------------------------------------
     srv-zx1hd  creating  nano  gb1-b  2011-03-15  img-4gqhs             my first server
    -------------------------------------------------------------------------------------

Note that the new server has been given the identifier `srv-zx1hd`.
It has also been given the default server type `nano`. When you want
to build a bigger server you'll need to know more about
[server types](/references/server-types.html), but don't worry about
them for now.

If you wait a few moments and show the details of the new server, it
should have changed from status `creating` to status `active`, which
means it's booted:

    $ brightbox-servers show srv-zx1hd
                 id: srv-zx1hd
             status: active
               name: my first server
        description: 
         created_at: 2011-03-15T13:01
         deleted_at: 
               zone: gb1-b
               type: typ-4nssg
          type_name: Brightbox Nano Instance
        type_handle: nano
                ram: 384
              cores: 1
               disk: 10240
              image: img-4gqhs
         image_name: 
        private_ips: 10.146.19.166
          cloud_ips: 
       cloud_ip_ids: 
           hostname: srv-zx1hd.gb1.brightbox.com
    public_hostname: 
          snapshots: 
			
### Mapping a cloud IP

So now you have a server but it only has a private IP address. To
access it over the internet you need to map a
[Cloud IP](/references/cloud-ips.html) to it. Firstly, create a cloud
IP on your account:

    $ brightbox-cloudips create
    
     id         status    public_ip       server_id  interface_id  reverse_dns                            
    -------------------------------------------------------------------------------------------------------
     cip-3b0ha  unmapped  109.107.35.239                           cip-109-107-35-239.gb1.brightbox.com
    -------------------------------------------------------------------------------------------------------

Then map it to your server using the cloud ip's id and your server's id:

    $ brightbox-cloudips map cip-3b0ha srv-zx1hd
    Mapping cip-3b0ha to interface int-x4kve on srv-zx1hd
    
     id         status  public_ip       server_id  interface_id  reverse_dns                            
    -----------------------------------------------------------------------------------------------------
     cip-3b0ha  mapped  109.107.35.239  srv-zx1hd  int-x4kve     cip-109-107-35-239.gb1.brightbox.com
    -----------------------------------------------------------------------------------------------------

Now you can log in via ssh using your ssh key. Remember, this image uses the `ubuntu` account by default:

    $ ssh ubuntu@109.107.35.239
    Linux srv-zx1hd 2.6.32-24-generic-pae #42-Ubuntu SMP Fri Aug 20 15:37:22 UTC 2010 i686 GNU/Linux
    Ubuntu 10.04.1 LTS
    
    ubuntu@srv-zx1hd:~$ uptime
     13:02:07 up  0:01,  1 user,  load average: 0.04, 0.01, 0.00

## Would you like to know more?

Here you installed and configured the Command Line Interface tool,
created an Ubuntu server, mapped a Cloud IP to it and sshed in.

You might want to learn more about [Cloud IPs](/guides/cli/cloud-ips.html),
[discover zones](/references/definitions.html#zone) or learn how to
[Create a snapshot](/guides/cli/create-a-snapshot.html).

<small>Join the Mobile Infantry and save the Galaxy. Service
guarantees citizenship.</small>
