---
title: CoreOS on Brightbox Cloud
tags: [docker, containers, coreos]
keywords: coreos
---

<img src="/images/coreos-logo.png" class="doc-right" alt=""/>
[CoreOS](https://coreos.com/) is a new lightweight Linux distribution for running modern infrastructure stacks.

It has no package manager and instead requires that all applications run inside [Docker containers](/docs/docker/).

It has built in support for advanced clustering configurations but runs just as well as a single system.

CoreOS is officially supported on Brightbox Cloud and is an easy way to get up and running with Docker. We auto-import both the stable CoreOS images and the daily development images.

You can just search for <code>core</code> in the image library and choose the images marked official.

### CoreOS reference documentation and guides

* [Building a CoreOS Cluster with the Brightbox CLI](/docs/guides/cli/coreos/)
* [Running a private Docker registry on CoreOS](/docs/guides/docker/private-registry-with-orbit/)

