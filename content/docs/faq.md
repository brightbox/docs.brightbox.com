---
title: Frequently Asked Questions
label: FAQ
tags: [faq]
layout: default
---

### General

#### What is the password for my new Cloud Server?

New Cloud Servers are not automatically given new passwords. Most
[Server Images](/docs/reference/server-images/) are configured to install your ssh
key from the [user data](/docs/guides/cli/user-data/) service.

So, just make sure that you have provided your ssh key with
[Brightbox Manager](/docs/guides/manager/ssh-keys/) or with the
[cli](/docs/guides/cli/getting-started/#configuring_your_ssh_key) and
you'll be able to access new Cloud Servers.

Updating your key does not add it to existing servers - it only
affects new servers.

See the [Accessing Cloud Servers](/docs/guides/accessing-cloud-servers/) guide for more details.

#### How do I resize my Cloud Server?

In-place resizing of Cloud Servers is not supported, but you can
[snapshot your server](/docs/guides/cli/create-a-snapshot/) and use the resulting snapshot image to create a new Cloud Server.

If you want to resize down to a Cloud Server Type with a smaller disk, you'll need to [shrink the filesystem and partition](/docs/guides/manager/resizing-a-snapshot/).

#### I updated the SSH public key for my user, why hasn't it updated on my Cloud Servers?

SSH keys are only installed on first boot, using a script that gets your key
from the [metadata service](/docs/reference/metadata-service).

Updating your SSH key will not distribute the updated key to your existing
Cloud Servers.

See the [Accessing Cloud Servers](/docs/guides/accessing-cloud-servers/) guide for more details.

#### How do I access the RDP service on my Windows server?

Make sure you've opened access to the RDP service (tcp port 3306) to your server using the [firewall policy](/docs/reference/firewall/).

#### How can I use my own disk images in Brightbox Cloud?

You can upload them to the Image Library, register them, and then use them like any other Cloud Server image. See the
[Image Library Guide](/docs/guides/cli/image-library/) for more details.

#### Why is the filesystem on my Cloud Servers so small?

Most images have a small partition on them by default, even though
your Cloud Server may have a much larger disk. To make use of the full
disk space you need to grow the partition and file system.

Some of the Brightbox official images (notably the Ubuntu images) automatically
grow the partition and filesystem on first boot.

See the [Filesystems and disks](/docs/guides/filesystems-and-disks/) guide for more
details.

