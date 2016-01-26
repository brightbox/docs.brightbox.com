---
layout: default
title: Resizing a snapshot to fit on a smaller server type
section: Brightbox Manager
keywords: resize, downgrade
---

Growing a server from a smaller server type to a larger one is easy. You just snapshot the server and build a newer, larger one from the snapshot and you're ready to go. Most of our images auto-grow the filesystem on boot when it notices a larger disk.

Shrinking down from a larger server type to a smaller one is a little more involved, as the snapshot is too big to fit on the smaller disk. So you need to modify the image a bit to shrink it down, so that it'll fit.

### Image sizes

There are two sizes associated with server snapshots and other images, the virtual size and the data size. The virtual size, is how big the image looks to the server, which is dependent on the server type you first used.

The data size is how much actual non-zero data is stored in the image. So if you have an image with a virtual size of 20GB, but you only put 5GB of files on it then the data size might just be 5GB. If you downloaded the image, you'd get a 5GB file, not a 20GB file.

It's not *quite* as simple as this, as modern filesystems shuffled data around the disk and don't always zero it, so you might have only 5GB of data on the filesystem but the data size might be more than this, but it'll never be more than the virtual size.

So, to fit an image with a large virtual size onto a server type with a smaller disk, we need to shrink down the virtual size. To do this, we need to shrink down the filesystem and then shrink down the partition that contains it.

Then we can re-register the new, smaller, image and build new, smaller, servers with it.

### Build a processing server

Since we'll be downloading large images and processing them, it's best to do this work on a server in Brightbox Cloud, so your Internet connection won't slow you down.

So build a server that's big enough to download your snapshot to - you'll actually need to store at least 2 copies of the image, so make it big enough for that. You'll only need it for a few minutes so it won't cost much to run.

Use a recent official Ubuntu image, Utopic should be fine. Map a Cloud IP if you need to, SSH in and install some required tools:

    #!shell
    $ sudo apt-get update
	$ sudo apt-get install qemu-utils kpartx parted lftp

### Download the snapshot

We need a local copy of the snapshot to work on. Snapshots are stored in the `images` container of [Orbit](/docs/reference/orbit/), our storage service. You can access the images using [SFTP](/docs/guides/orbit/sftp/), or using the OpenStack Swift command client, or simply by using a temporary url generated in Brightbox Manager. SFTP is a little slower than accessing Orbit directly, so we'll access it directly here:

    #!shell
    $ wget -O img-3anq3  "https://orbit.brightbox.com/v1/acc-xxxxx/images/img-3anq3?temp_url_sig=7725f88959e1017&temp_url_expires=1421876813"
    
    2015-01-21 21:31:35 (75.2 MB/s) - 'img-3anq3' saved

### Convert it to raw format

The downloaded snapshot will be in QCOW2 format, so convert it to a raw file using `qemu-img`:

    #!shell
    $ qemu-img convert -O raw img-3anq3 img-3anq3.raw

This will create a file called `img-3anq3.raw` which is sparsely allocated, so it will look to be the full virtual size of the image but will only be the size of the actual image data.

You can delete the original image file now if you need the space, we won't need it again (unless you make a mistake!).

### Map the partitions from the image file

So now we have a raw image file on disk. It doesn't contain the filesystem directly but instead has a partition table. That means we can't access the filesystem directly and instead have to use the `kpartx` tool to setup devices that point to the partitions inside this file.

    #!shell
    $ sudo kpartx -av img-3anq3.raw
    add map loop0p1 (252:0): 0 83884032 linear /dev/loop0 2048

So now we have a device named `/dev/mapper/loop0p1` which is mapped the first partition inside the `img-3anq3.raw` file.

### Resize the filesystem

We can now access the filesystem directly, so we can use normal filesystem tools.

So now we need to shrink down the filesystem to a reasonable size. Brightbox Cloud's smallest server type (Nano) has a 20GB disk, so if you're targeting that we'll need to go at least that small. Ideally, go as small as you can - you can grow it back up to the new size once you've built your new server (and most of our Linux images, particularly the Ubuntu images, will grow it for you automatically on boot).

First, run the filesystem check on it. Most of our images use `ext4`, but if you've got something custom then use the appropriate tools:

    #!shell
    $ e2fsck -fy /dev/mapper/loop0p1
    
    e2fsck 1.42.10 (18-May-2014)
    Pass 1: Checking inodes, blocks, and sizes
    Pass 2: Checking directory structure
    Pass 3: Checking directory connectivity
    Pass 4: Checking reference counts
    Pass 5: Checking group summary information
    cloudimg-rootfs: 200564/2621440 files (0.1% non-contiguous),     693124/10485504 blocks

If you snapshotted a running server, there might be one or two minor filesystem fixes made but it shouldn't be a concern.

Now resize the filesystem - we'll go with 5GB in this example:

    #!shell
    $ resize2fs /dev/mapper/loop0p1 5120M
    
    resize2fs 1.42.10 (18-May-2014)
    Resizing the filesystem on /dev/mapper/loop0p1 to 1310720 (4k) blocks.
    The filesystem on /dev/mapper/loop0p1 is now 1310720 blocks long.

We're done with the filesystem now, so we can remove the devices that were setup by `kpartx`:

    #!shell
    $ sudo kpartx -d img-3anq3.raw
    loop deleted : /dev/loop0

### Resize the partition

We've shrunk down the filesystem so now we can shrink down the partition that contains it, using `parted`.

When resizing, you tell `parted` *where you want the partition to end rather than how big you want the partition*. A bit perplexing, but there we are. Most of our images have the partition starting at an offset of 1 megabyte, so resize to one megabyte larger than you made the filesystem (you can double check by listing the partitions and noting the `Start` position):

    #!shell
    $ parted img-3anq3.raw 

    (parted) resizepart 1 5121MiB
    Warning: Shrinking a partition can cause data loss, are you sure you want to continue?
    Yes/No? Yes
    (parted) quit

### Resize the image

So now that the filesystem is shrunk, and the partition is shrunk, the only thing left is the actual "disk", which for a raw image file is just the file size. `qemu-img` can help us here too though. Shrink the image down to one megabyte bigger than your partition, for good luck:

    #!shell
    $ qemu-img resize img-3anq3.raw 5122M
    Image resized.

### Convert the image back to QCOW2 format

Now we have a resized raw image, so we just need to convert it back to QCOW2 format:

    #!shell
    $ qemu-img convert -O qcow2 -o compat=0.10 img-3anq3.raw img-3anq3.qcow2

### Register the newly resized image

<img src="/images/docs/image-library-access.png" alt="" class="doc-right"/>

Now we've modified the image to the size we want it, we need to register it back with the Image Library so we can build new servers from it.

Firstly, upload the new image to the Image Library incoming area using FTP. To generate a new random FTP password for your access click on the cog icon at the top left of the page in Brightbox Manager. This drops down the account menu; then click <q>Image Library access</q>.

<br class="clear"/>

Then use your favourite FTP client to upload the new image:

    #!shell
    $ lftp acc-xxxxx@ftp.library.gb1.brightbox.com
        Password:
    
    lftp acc-xxxxx@ftp.library.gb1.brightbox.com:~> ls
    
    drwxr-sr-x   2 acc-xxxxx library     20480 Sep 24  2013 images
	drwxr-sr-x   2 acc-xxxxx library     20480 Sep 24  2013 incoming
    
    lftp acc-xxxxx@ftp.library.gb1.brightbox.com:/> cd incoming
    
    lftp acc-xxxxx@ftp.library.gb1.brightbox.com:/incoming> put img-3anq3.qcow2
    
    5368709120 bytes transferred


Then tell the Image Library to register it. Brightbox Manager doesn't currently support image registration, so you need to do this part with [the command line interface](/docs/guides/cli/). There is a [fuller guide to image registration](/docs/guides/cli/image-library/) available, but we'll cover the basics steps here.

Give the new image a name, specify the [cpu architecture](/docs/reference/server-images/#architecture) (`x84_64` should be fine for most situations) and the filename of the source file in the `incoming/` directory:

    #!shell
    $ brightbox images register -a x86_64 --name "resized image" --source img-3anq3.qcow
    
     id         owner      type    created_on  status    size  name
    ------------------------------------------------------------------------------------
     img-n246s  acc-h3nbk  upload  2015-01-22  creating  0     resized image (x86_64)
    ------------------------------------------------------------------------------------

The Image Library will then fetch the image from the `incoming` directory, check it and import it.  Once it has been processed it will move from state `creating` to state `available`, at which point you can use it to build a new server from.

### Summary

Modifying filesystems and partitions is fiddly and this isn't a simple procedure, but it results in an image you can use with any server type and at no point do you put your original data at risk, as all operations are done on a whole new image. So you can experiment without any risk and you can always go back to your original snapshot at any time.

