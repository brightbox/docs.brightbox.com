---
title: Frequently Asked Questions
label: FAQ
layout: default
---

### General

#### Why is my filesystem so small?

Most images have a small partition on them by default, even though
your server will have a much bigger disk. You just need to grow the
partition and filesystem. See the
[Filesystems and disks](/guides/filesystems-and-disks/) guide

#### How do I resize my server?

We don't support resizing in-place. You need to
[snapshot your server](/guides/cli/create-a-snapshot/) and create
a new one using the snapshot.  You'll need to shrink the filesystem
and partition if you want to resize to a smaller disk.
