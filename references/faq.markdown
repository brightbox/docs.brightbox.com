---
layout: default
title: Frequently Asked Questions
---

### Why is my filesystem so small?

Most images have a small partition on them by default, even though
your server will have a much bigger disk. You just need to grow the
partition and filesystem.

Some images (notably the Ubuntu images) automatically grow the partition and filesystem on first boot.

See the
[Filesystems and disks](/guides/filesystems-and-disks.html) guide for more details.

### How do I resize my server?

We don't support resizing in-place. You need to
[snapshot your server](/guides/cli/create-a-snapshot.html) and create
a new one using the snapshot.  You'll need to shrink the filesystem
and partition if you want to resize to a smaller disk.

### I changed my ssh key using the cli or the gui but it didn't update on my servers

Updating your ssh key with our systems only affects new servers, it doesn't automatically distribute the key to your existing servers.

The ssh keys are installed on first boot using a script that gets your key from the [metadata service](/reference/metadata-service.html).

### How do I use my own disk images?

You can upload them to the Image Library, register them, and then use then like any other image.  See the [Image Library Guide](/guides/cli/image-library.html) for more details.