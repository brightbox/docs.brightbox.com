---
layout: default
title: Cloud Servers
section: Reference
---

Cloud Servers are individual virtual machine instances, created from a specific [Image](/docs/reference/server-images) and of a specific [Server Type](/docs/reference/server-types), belonging to an [Account](/docs/reference/accounts).

### Billing

Cloud Server usage is billed by the hour from the moment they are created until they are destroyed. Servers in both `active` and `inactive` state are billed for. Billing only stops when a server is deleted.

### Networking

By default, each Cloud Server has a private IPv4 address and a block of IPv6 addresses. Additional public IPv4 addresses can be added and removed to them using the [Cloud IP](/docs/reference/cloud-ips) functionality. More information can be found in the [network reference](/docs/reference/network/).

Cloud Servers have a number of [dns records](/docs/reference/dns) associated with them.

### Firewalling

Access to and from Cloud Servers can be controlled using the [Cloud Firewall](/docs/reference/firewall/).

### Load Balancing

Cloud Servers can be added as backends to [Load Balancers](/docs/reference/load-balancers/).
