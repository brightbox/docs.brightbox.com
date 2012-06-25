---
layout: default
title: Image Library
---

The image library holds [Server Images](/reference/server-images/) and
snapshots. When you create a new server with a particular Image, the
build systems retrieve the Image from the Image Library. When you
snapshot a server, the resulting Image is uploaded to the Image
Library.


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
     img-7geqi  acc-xxxxx  upload  2011-05-19  creating  0     slackware (i686)
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
     img-7geqi  acc-xxxxx  upload    2011-05-19  private  3050   Slackware (i686)                           
    ---------------------------------------------------------------------------------------------------------

And it can be used to build servers in the usual manner:

    $ brightbox-servers create -n "my slackware box" img-7geqi
		
### Compatibility mode

Brightbox Cloud Servers are created by default with what are called
`virtio` devices. `virtio` devices allow for higher performance but
require that the operating system have proper support for them.

If your operating system does not support `virtio` then it will not be
able to access the network or disk devices.

Most modern Linux kernels have `virtio` support built-in, but many
other operating systems, such as FreeBSD or Microsoft Windows, do not.

Compatibility mode disables `virtio`, which allows a broader range of
operating systems to work without modification.

So to use compatibility mode, you set it on a particular image:

    $ brightbox-images update --mode=compatibility img-7geqi

From then on, any new servers created with this image are put in
compatibility mode and will work without `virtio` drivers.



### Image access

Uploaded images and snapshot images are private by default, which
means only the account that owns them can list them or build servers
from them.

If you make an image public, other Brightbox Cloud users can see them
and build servers from them:

    $ brightbox-images update --public=true img-7geqi

### Deprecated images

If you've got an image that is public and you release a new version of
it, you'll probably want to remove the old version. However, this may
affect other users who might have hard-coded your image's identifier
into their build scripts. Rather than remove the old version, you can
mark it as deprecated.

A deprecated image is still available for use to those who know the
identifier, but it does not show up in image listings so shouldn't
invite any new users.

Deprecated images that you own still shows up in your listings, but
are listed with the status `deprecated`:

    brightbox-images update --deprecated=true img-7geqi
    
    Updating image img-7geqi
    
     id         owner      type    created_on  status      size  name            
    ------------------------------------------------------------------------------
     img-7geqi  acc-xxxxx  upload  2011-05-19  deprecated  3050  slackware (i686)
    ------------------------------------------------------------------------------

### Image Format

The registration service can handle raw format images, compressed raw
images, or compressed image formats supported by the kvm 'qemu-img' tool.

