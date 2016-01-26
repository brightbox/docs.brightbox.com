---
title: Filesystems and Disks
layout: default
tags: [filesystem, disk, partition, growpart, sfdisk, lvm, resize2fs]
---

Most [Server Images](/docs/reference/server-images/) provide a small
partition by default, perhaps two gigabytes. This allows the Image to
be used on all [Server Types](/docs/reference/glossary/#server_type)
because there will always be enough space for it.

Some Images (in particular the Ubuntu images) are rigged to
automatically grow the partition and file system during the first boot
(you can control this behaviour if you wish with special
[user data](/docs/guides/cli/user-data/)).

Most other images leave the work for you to do manually, so when you
first boot a server the file system might look very small:

    #!shell
    $ df -h
    Filesystem            Size  Used Avail Use% Mounted on
    /dev/vda1             1.3G  754M  501M  61% /

And the partition table might look like this:

    #!shell
    $ sfdisk -uM -l /dev/vda
    
    Disk /dev/vda: 20805 cylinders, 16 heads, 63 sectors/track
    Units = mebibytes of 1048576 bytes, blocks of 1024 bytes, counting from 0
    
       Device Boot Start   End    MiB    #blocks   Id  System
    /dev/vda1         0+  1341-  1342-   1374023   83  Linux

The actual disk is the full size as per the Server Type, but the
Images partition table just doesn't use it all by default.

To make use of your whole disk, you'll want to grow the partition and
then grow the file system.

If the image is Ubuntu Natty or newer, you can use the `growpart` tool
to grow the partition:

    #!shell
    $ growpart /dev/vda 1

If the image is an older Ubuntu, you can usually grow the main
partition automatically using the `sfdisk` tool and a bit of scripting:

    #!shell
    $ START=`sfdisk -uS /dev/vda -d | grep vda1 | awk '{print $4}'` && printf "$START\n;0\n;0\n;0\n" | sfdisk --force -uS -x /dev/vda

**WARNING:** The above script blindly grows the first partition to the
entire size of your disk, overwriting any other partitions. It has
only been tested with our official Ubuntu images.

After resizing the partition you need to reload the partition table,
which usually needs a reboot. Then you can grow the file system.

In the case of the Ubuntu images, you can grow the default filesystem
like this:

    #!shell
    $ resize2fs /dev/vda1

Our official Centos images comes with LVM, so you grow the partition
and then grow the LVM PV. Other images may have different
arrangements.
