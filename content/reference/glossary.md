---
layout: default
title: Glossary
---

### Account

Brightbox services are provided through an Account. A typical customer has at
least one Account through which they manage their resources, such as 
[Cloud Servers](#cloud_server) and [Load Balancers](#load_balancer). It is possible
to create multiple Accounts, for example, to manage resources for separate
customers of your own.

See the [Accounts](/reference/accounts/) page for more information.

### Account Limits

Each Account is created with default resource limits which determine the total
[Cloud Server](#cloud_server) RAM, the number of [Cloud IPs](#cloud_ip) and the
number of [Load Balancers](#load_balancer) which may be in use at any one time.
A default limit is applied to all new Accounts on creation, but you can request
an increase to each of the 3 limits at any time via
[Brightbox Manager](#brightbox_manager).

### API Client

An [API Client](/reference/api-clients/) is a set of credentials
(client_id and secret), belonging to an Account, used to authenticate
with the [API](/reference/api) via OAuth 2.0

Each Account can have multiple API Clients.

### Brightbox Manager

Brightbox Manager is a web-based GUI which can be used to create and
manage Brightbox Accounts and update billing details etc.  It's
accessible at https://manage.brightbox.com

### CLI

The CLI (or "Command Line Interface") is the primary method of creating and
managing resources, such as Cloud Servers and Load Balancers, with Brightbox
Cloud.

See the [CLI guide](/guides/cli/) for more information.

### Cloud IP

Cloud IPs are publicly accessible IP addresses that can be mapped instantly
to [Cloud Servers](#cloud_server) and [Load Balancers](#load_balancer). Cloud IPs
belong to the Account they are created on until they are destroyed (i.e released 
back into the pool for other customers to use).

Cloud IPs can be mapped and re-mapped to any Cloud Server or Load Balancer
belonging to the same [Account](#account), even across [Zones](#zone) within
the same [Region](#region).

For more information on Cloud IPs, see the [Cloud IP guide](/guides/cli/cloud-ips/).

### Cloud Server

A Cloud Server (or "Server") is a single cloud virtual machine, created from a
specific [Image](#image) and of a specific [Server Type](#server_type), belonging
to an [Account](#account).

### Console

The [Graphical Console](/guides/cli/graphical-console/) provides
direct access to a Cloud Server, as if sat at a physical keyboard.

### Firewall

The Cloud Firewall is a distributed stateful firewall for controlling
access to, from and between Cloud Servers.  See the
[Cloud Firewall Reference](/reference/firewall/) for more information.

### Firewall Policy

A Firewall Policy represents a list of
[Firewall Rules](#firewall_rule) and is usually associated with a
[Server Group](#server_group).

### Firewall Rule

A Firewall Rule defines some kind of network traffic to be accepted by
the [Cloud Firewall](#firewall). It is always associated with a
[Firewall Policy](#firewall_policy).

### Image

An Image (or Cloud Server Image) is a virtual disk image from which a
[Cloud Server](#cloud_server) can be created. Brightbox provides several "official"
images for common OSes, but you can create your own - either by
[snapshotting existing servers](/guides/cli/create-a-snapshot/) or uploading
new images (see [Image Library Guide](/guides/cli/image-library)).

For for more information, see the
[Server Image reference](/reference/server-images/).

### Image Library

The image library provides storage for [Images](#image). It can be used to
download (export) snapshots, or upload new images for use in Brightbox Cloud.

For more information on the Image Library, see the
[Image Library guide](/guides/cli/image-library/).

### Interface

An Interface (or "Network Interface" or "Cloud Server Interface") represents
the virtual network interface of a Cloud Server. Currently, a single Interface is
created on each Cloud Server - but it is planned that multiple Interfaces will
be supported in future.

### Load Balancer

A Load Balancer (or "Cloud Balancer") is an individual cloud Load Balancer
instance belonging to an [Account](#account). Load Balancers enable you to 
create scalable and fault tolerant systems by distributing traffic across a
pool of [Cloud Servers](#cloud_server), which can be located in multiple
[Zones](#zone) within the same [Region](#region).

Each Load Balancer can balance multiple protocols at once and is highly
available across a Region - designed to tolerate the loss of an entire
Zone without disruption.

For more information, see the [Load Balancer guide](/guides/cli/load-balancers)

### Server Group

A Server Group is a logical grouping of
[Cloud Servers](#cloud_server). They’re the foundation of other
Brightbox Cloud features, such as the
[Cloud Firewall](#cloud_firewall). For more information see the
[Server Group guide](/guides/cli/server-groups/).

### Server Type

A Server Type represents a particular set of [Cloud Server](#cloud_server)
specifications, in terms of RAM size, disk size and number of CPU cores.

For example, a "Small" Server Type specifies 2048MB of RAM, 81920MB disk and
4 CPU cores.

### Region

A Region represents a geographical area which contains one or more [Zones](#zone).

Regions are identified by a region code, which consists of a 2-letter
[ISO 3166-1](http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2) country code
followed by a digit e.g. GB1, DE1, US2 etc.

At present there is one Region (GB1), located in Northern England, UK.

### User

A User represents a person. It may have access to many accounts, whether as
the Owner or with limited permissions.

### User Data

User Data is arbitrary metadata that can be specified when creating a new
[Cloud Server](#cloud_server). The specified user data is available to the Server
via the [Metadata service](/guides/cli/user-data/).

### Zone

A Zone represents an individual Brightbox datacentre location. Zones are physically
isolated from others within the same [Region](#region), but are interconnected
by diverse, redundant, low latency fibre links.

For geographic redundancy, simply create [Cloud Servers](#cloud_server) in multiple
Zones and use [Load Balancing](#load_balancer) to distribute traffic across them.


