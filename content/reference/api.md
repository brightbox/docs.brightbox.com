---
layout: default
title: API
---

Brightbox Cloud resources can be managed completely via the RESTful HTTP API.

Full reference documentation for the API is [available here.](https://api.gb1.brightbox.com/1.0/)

### Client software

The following software is compatible with, or features support for, the 
Brightbox API.

#### Brightbox CLI

The most mature tool for interacting with the API is the Brightbox CLI, 
written in Ruby. See the [CLI documentation](/guides/cli/) for more information.

#### Fog: the Ruby cloud computing library

We've added support for the Brightbox Cloud API to [Fog](http://fog.io) "The 
Ruby cloud services library". The Brightbox CLI uses Fog.

#### Apache Libcloud

[Libcloud](http://libcloud.apache.org/) is a standard Python library that
abstracts away differences among multiple cloud provider APIs.

#### Chef Knife

A [Knife](http://wiki.opscode.com/display/chef/Knife) plugin for the Brightbox 
API is [available on GitHub](https://github.com/rubiojr/knife-brightbox).

Knife is the command-line tool which is part of the configuration management
framework [Chef](http://wiki.opscode.com/display/chef/Home).




