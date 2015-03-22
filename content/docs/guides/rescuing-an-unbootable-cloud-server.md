---
layout: default
title: Rescuing an unbootable Cloud Server
keywords: rescue recovery recover
---

It's pretty easy to mis-configure something and render one of your servers unbootable. Luckily, with the wonders of PXE, it's pretty easy to boot into a system rescue tool and fix the problem. Here's how.

### Graphical console

Firstly, open up the graphical console for your Cloud Server. You can do this with either [Brightbox Manager](/docs/guides/manager/graphical-console/) or the [command line interface](/docs/guides/cli/graphical-console/).

### Boot into the PXE system

PXE stands for "Preboot eXecution Environment", and every Cloud Server can be made to boot into this instead of booting into the installed operating system. You just need to hit <q>CTRL + B</q> as it first starts to boot.

So hit the <q>Send CtrlAltDel</q> button in the graphical console to start a reboot of your system if you can. If you broke things so hard this doesn't work, you'll need to stop and start your server using the manager action menu (this kicks you out of the graphical console, so you'll need to be quick to bring it back up in time after a start!)

<img src="/images/docs/graphical-console-gpxe.png" alt="" class="doc-border doc-center"/>

### Setup PXE networking

PXE itself is a pretty limited environment, so we just use it to boot into a proper system rescue tool. To get that tool we'll need networking configured, which is easy with dhcp. Just type:

    dhcp net0

### Boot into a system rescue tool

Now we can tell PXE to download a system rescue image into memory and boot from it. We provide a local copy of [SystemRescueCD](http://www.sysresccd.org/SystemRescueCd_Homepage) for this exact purpose, and we provide a little PXE script to make it easy to use. Just type:

    chain http://d.brightbox.com/pxe/systemrescue

And it'll be downloaded and booted for you

<img src="/images/docs/graphical-console-gpxe-rescue.png" alt="" class="doc-center doc-border"/>

During boot it'll ask what keyboard mapping you want; United Kingdom is number `40`.

### Access your servers filesystem

Now that SystemRescue is booted, you can mount your Cloud Server's filesystem and fix whatever you broke. The server's disk is `/dev/vda` and most of our Linux images have the first partition, `/dev/vda1`, as the main filesystem.

So just make a mount point and mount it:

    mkdir /mnt/vda1
    mount /dev/vda1 /mnt/vda1

If you're rescuing a Windows server, then it's probably partition 2, so `/dev/vda2`.

If you have a more advanced storage layout like LVM then it's a little trickier, but SystemRescue should have all the tools you need.

When you're done, just type `reboot` and the filesystem will be unmounted and your server will reboot back into it's operating system!

### SSH access

SystemRescue starts up an ssh daemon by default, so just set a password by running `passwd root` and you can ssh into the rescue environment.  Handy if you just want to just take a copy of your data from an unbootable system.

