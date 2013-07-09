---
title: Frequently Asked Questions
label: FAQ
tags: [faq]
layout: default
---

### General

#### What is the password for my new Cloud Server?

New servers are not automatically given new passwords. Most
[Server Images](/reference/server-images/) are configured to install your ssh
key from the [user data](/guides/cli/user-data/) service.

So, just make sure that you have provided your ssh key with
[Brightbox Manager](/guides/manager/ssh-keys/) or with the
[cli](/guides/cli/getting-started/#configuring_your_ssh_key) and
you'll be able to access new servers.

Updating your key does not add it to existing servers - it only
affects new servers.

#### Why is the filesystem on my Cloud Servers so small?

Most images have a small partition on them by default, even though
your Cloud Server may have a much larger disk. To make use of the full
disk space you need to grow the partition and file system.

Some of the Brightbox official images (notably the Ubuntu images) automatically
grow the partition and filesystem on first boot.

See the [Filesystems and disks](/guides/filesystems-and-disks/) guide for more
details.

#### How do I resize my Cloud Server?

In-place resizing of Cloud Servers is not supported, but you can
[snapshot your server](/guides/cli/create-a-snapshot/) and use the resulting
snapshot image to create a new Cloud Server.

If you want to resize down to a Cloud Server Type with a smaller disk, you'll
need to shrink the filesystem and partition before taking the snapshot.

#### I updated the SSH public key for my user, why hasn't it updated on my Cloud Servers?

SSH keys are only installed on first boot, using a script that gets your key
from the [metadata service](/reference/metadata-service).

Updating your SSH key will not distribute the updated key to your existing
Cloud Servers.

#### How can I use my own disk images in Brightbox Cloud?

You can upload them to the Image Library, register them, and then use them like
any other Cloud Server image. See the
[Image Library Guide](/guides/cli/image-library/) for more details.

