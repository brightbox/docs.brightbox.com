---
layout: default
title: Images
---

An Image (or Cloud Server Image) is a copy of a virtual disk from
which a [Cloud Server](#cloud_server) can be built. Brightbox provides
several "official" images for common OSes, but you can supply your own
(and share them with other users if you like).

To create your own image, you can either
[snapshot an existing server](/guides/cli/create-a-snapshot/) or
upload a new image to the Image library and register it (see
[Image Library Guide](/guides/cli/image-library) for a walk-though)

Images can be managed using the `brightbox images` command line tool.

The Image you choose affects some aspects of the Server it is used to
create.

### Architecture

Each Image has an architecture attribute, either `i686` (32bit) or
`x86_64` (64bit), which sets the architecture of your new server.

### Mode

An Image can be set to one of two modes: `virtio` or `compatibility`.

An Image with the mode `virtio` creates servers with `virtio` virtual
devices. `virtio` devices allow for higher performance but require
that the operating system have proper support for them.

If your operating system does not support `virtio` then it will not be
able to access the network or disk devices.

Most modern Linux kernels have `virtio` support built-in, but many
other operating systems, such as FreeBSD or Microsoft Windows, do not.

`compatibility` mode replaces any `virtio` devices with emulated
equivalents, which allows a broader range of operating systems to work
without modification at the cost of some performance.

More information on `virtio`, including some details about the Windows
drivers, can be found on the
[libvirt wiki](http://wiki.libvirt.org/page/Virtio).

### Status

An Image can be in one of several states, which affects how it can be
used and how it is displayed.  An Image with status `available` can be
used to build new servers.  You can monitor the progress of an Image
in `creating` state by watching the `disk_size` attribute.

#### Creating

Status `creating` means the Image is currently being created, either
from a server being snapshotted or an uploaded Image being registered.
Images in the state `creating` cannot be used to build new servers.

#### Deleted

Status `deleted` means the Image has been removed from the Image
Library and is no longer available to build new servers.

#### Failed

Status `failed` means the Image was not successfully created - usually
indicating that either a server snapshot or a registration did not
succeed.

#### Deprecated

Status `deprecated` means the Image does not show up in the list, but
it is still available for building new servers to those who know the
identifier.  This is often used in the situation where you have an
image that is public and you want to release a new version of it.
Removing the old version straight away will affect any users who have
hard-coded your image's identifier into their build scripts. Setting
it as `deprecated` makes it clear it's not supposed to be used any
more, giving existing users a chance to update their systems.

### Image size

An Image is stored in the Image Library in a compressed format.
Basically, this means any zeroes in the Image don't actually take up
space in the Image Library.

So this means an Image has two different size attributes.  The
`disk_size` is how much actual non-zero data is in the Image.

The `virtual_size` is how big the Image is once uncompressed and
written to your Server (so including the zeroes).

This means that the [server type](/reference/glossary/#server_type)
you choose for your server must have a disk at least as big as the
`virtual_size` of your Image, or it will not fit.

The system will fail attempts to uploaded images and snapshot servers
that generate a compressed image bigger than 50GB.

### Username

The `username` attribute defines the default user account that the Image
is set up with.  This is usually the account that gets your ssh key on
first boot.

### Image Access

Both uploaded images and snapshot images are private by default, which
means only the account that owns them can list them or build servers
from them.

If you make an image public, other Brightbox Cloud users can see them
and build servers from them.

### Official Images

An Image with the attribute `official` set to true has been provided
by Brightbox.  It's mainly just used by the cli to display these
Images slightly differently to indicate they are trustworthy.
