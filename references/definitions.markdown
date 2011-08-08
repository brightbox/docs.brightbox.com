---
layout: default
title: Definitions
---

### Server
A Server is a single cloud virtual machine running a particular
image.


### Zone

Zone represents cloud resources at a datacentre. Each Zone is
completely isolated in terms of power, cooling, security and
networking equipment.


### Server Type

A Server Type represents a particular server specification: ram size,
disk size and number of cpu cores.  You can learn more about them in
the [Server Type reference](/references/server-types.html).

### Image

An Image is virtual disk image used as the basis of a
server. Brightbox provide several "official" images for common OSes,
but users can create their own by
[snapshotting existing servers](/guides/cli/create-a-snapshot.html) or
uploading new images.


### Cloud IP

Cloud IPs are publicly accessible IP addresses that can be moved
instantly between servers in the Brightbox Cloud. They belong to an
account until they are destroyed. Once created they can be mapped to
any server belonging to the same account, even across zones within the
same region.

You can learn more about them in the
[Cloud IP guide](/guides/cli/cloud-ips.html)

### Account

Brightbox services are provided through an Account. A typical customer
has at least one Account through which they buy their Servers and
other services. They may create multiple accounts if they wish e.g to
manage servers for separate clients of theirs.

Accounts have limits on the resources that they can use. This is
currently the total RAM that all Servers can take up and the number of
Cloud IP addresses the account can request.


### API Client

An API Client is a set of credentials (client_id and secret) belonging
to an Account used to authenticate with the API via OAuth2.0

Each Account can have multiple API Clients.


### User

A user represents a person. It may have access to many accounts,
whether as the Owner or with limited permissions.


### User Data

User data is arbitrary metadata that can be specified when creating a
new server. The user data is available to the server from the [Metadata
server](/guides/cli/user-data.html).


### Image Library

The image library holds all the server images. It can be used to
download snapshots, or upload new images for registration. You can
learn more about it in the
[image library guide](/guides/cli/image-library.html).


