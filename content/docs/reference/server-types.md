---
layout: default
title: Server Types
---

A Server Type represents a particular set of [Cloud Server](/docs/reference/cloud-servers/) specifications, in terms of RAM size, disk size/type and number of CPU cores. There are a range of server types suitable for varying workloads and have different [hourly costs](http://brightbox.com/pricing/#cloud_servers).

A server type is chosen when first building a Cloud Server and cannot be changed. To resize a server, snapshot it and rebuild with the required type.

#### Server Type Tiers

There are two main tiers of Server Types, "Standard" and "High IO".

High IO server types are have more CPU cores, a higher share of CPU and a storage backend optimised for performance. Good for database and other IO-bound workloads.

"Standard" server types are optimised for agility, building and snapshotting performance due to a more flexible storage back end.

So, for example, a "High IO Small" Server Type specifies 2GB of RAM, 80GB disk and 4 CPU cores, with a high performance storage backend that costs £0.08/hour. A "Standard Small" Server Type specifies 2GB of RAM, 80GB disk and 2 CPU cores, with a standard performance storage backend and costs £0.06.

