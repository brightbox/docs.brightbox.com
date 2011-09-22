---
layout: default
title: Image Library
---

The image library holds disk images and snapshots. When you create a
new server with a particular image, the build systems retrieve the
image from the image library. When you snapshot a server, the
resulting image is uploaded to the image library.


### FTP access

You can upload new images or download snapshots using TLS encrypted
FTP. Firstly, you need to reset your ftp password. So get your account
id:

    $ brightbox-accounts list
    
     id         name    cloud_ip_limit  ram_limit  ram_used  ram_free
    ------------------------------------------------------------------
     acc-xxxxx  example 10              90000      5120      84880   
     ------------------------------------------------------------------

and reset the password:

    $ brightbox-accounts reset_ftp_password acc-xxxxx
    Resetting ftp password for acc-xxxxx
                      id: acc-xxxxx
                    name: example
        library_ftp_host: ftp.library.gb1.brightbox.com
        library_ftp_user: acc-xxxxx
    library_ftp_password: mynewpassword

You can now just use your ftp client to access the library:

    $ lftp acc-xxxxx@ftp.library.gb1.brightbox.com
    Password: 
    lftp acc-xxxxx@ftp.library.gb1.brightbox.com:~> ls    
    drwxr-sr-x   2 acc-xxxxx library      4096 May 17 11:16 images
    drwxr-sr-x   2 acc-xxxxx library      4096 May 17 11:17 incoming

The `incoming/` directory is where you should upload new images of your
own. You can then register them using the API and they are moved into
the `images/` directory (which is read-only). Any snapshots you create
using the API are also stored in the `images/` directory, for convenient
access.

### Registering a new image

Once you've uploaded your new image to the `incoming/` directory using
ftp, you register it. In this case I've uploaded a 32bit image called
`slackware.img`

    $ brightbox-images register -a i686 -n Slackware -d "Fresh slackware install" -s slackware.img
    
     id         owner      type    created_on  status    size  name            
    ----------------------------------------------------------------------------
     img-7geqi  acc-h3nbk  upload  2011-05-19  creating  0     slackware (i686)
    ----------------------------------------------------------------------------

Once it's been registered it will be deleted from `incoming/` and be
available in the `images/` directory named by the new images id
(`img-7geqi` in this case). You can see it listed via the API now:

    $ brightbox-images list
    
     id         owner      type      created_on  status   size   name                                       
    ---------------------------------------------------------------------------------------------------------
     img-hvqt1  brightbox  official  2011-04-18  public   2049   Ubuntu Hardy 8.04 server (i686)            
     img-687qk  brightbox  official  2011-04-18  public   2049   Ubuntu Hardy 8.04 server (x86_64)          
     img-2ab98  brightbox  official  2011-04-18  public   1409   Ubuntu Lucid 10.04 server (i686)           
     img-4gqhs  brightbox  official  2011-05-09  public   1409   Ubuntu Lucid 10.04 server (i686)           
     img-7geqi  acc-h3nbk  upload    2011-05-19  private  3050   Slackware (i686)                           
    ---------------------------------------------------------------------------------------------------------

And it can be used to build servers in the usual manner:

    $ brightbox-servers create -n "my slackware box" img-7geqi
