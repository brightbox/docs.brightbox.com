---
layout: default
title: Filesystems and Disks
---

Most images are smaller in size than the server disks are so that the
same image can be used on every server type without you worrying if it
will it.

So when you first boot a server the filesystem might look like this:

    $ df -h
    Filesystem            Size  Used Avail Use% Mounted on
    /dev/vda1             1.3G  754M  501M  61% /

And the partition table might look like this:

    $ sfdisk -uM -l /dev/vda
    
    Disk /dev/vda: 20805 cylinders, 16 heads, 63 sectors/track
    Units = mebibytes of 1048576 bytes, blocks of 1024 bytes, counting from 0
    
       Device Boot Start   End    MiB    #blocks   Id  System
    /dev/vda1         0+  1341-  1342-   1374023   83  Linux

To make use of your whole disk, you'll want to grow the partition and
then grow the filesystem.

If the image is Ubuntu Natty, you can use the growpart tool to grow
the partition:

    $ growpart /dev/vda 1

If the image is an older Ubuntu, you can usually grow the main
partition automatically using the sfdisk tool and a bit of scripting:

    $ START=`sfdisk -uS /dev/vda -d | grep vda1 | awk '{print $4}'` && printf "$START\n;0\n;0\n;0\n" | sfdisk --force -uS -x /dev/vda

WARNING: The above script blindly grows the first partition to the
entire size of your disk, overwriting any other partitions. It has
only been tested with our official Ubuntu images.

After resizing the partition you need to reload the partition table,
which usually needs a reboot. Then you can grow the filesystem.

In the case of the Ubuntu images, you can grow the default filesystem
like this:

    $ resize2fs /dev/vda1

Our official Centos images comes with LVM, so you grow the partition
and then grow the LVM PV. Other images may have different
arrangements.
