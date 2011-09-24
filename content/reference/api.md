---
layout: default
title: API
---

The Brightbox Cloud platform can be controlled completely via the RESTful HTTP API.

Full reference documentation for the API is [available here.](https://api.gb1.brightbox.com/1.0/)

## Clients

The following software is compatible with the Brightbox API.

### Brightbox command line interface
The most mature tool to interact with the API is currently the Brightbox CLI, written in Ruby. See the documentation for more details.

### Fog: the Ruby cloud computing library
We've added support for the Brightbox cloud API to [Fog](http://fog.io) "The Ruby cloud services library". The Brightbox CLI is written using Fog.

### Apache Libcloud
[Libcloud](http://libcloud.apache.org/) is a standard Python library that abstracts away differences among multiple cloud provider APIs. We added support for our API to libcloud, which is now included upstream.
