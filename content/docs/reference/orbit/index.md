---
layout: default
title: Orbit Object Storage
section: Reference
search: true
---

Orbit is Brightbox's durable and highly available data storage system, based on OpenStack Swift.

Every object is replicated to three distinct physical storage servers, which are distributed across two geographically distinct [availability zones](/docs/reference/glossary/#zone) (data centres).

Objects are usually files you want to store, and have associated metadata that describe the data and can change the way it is handled.

Objects are stored within containers, which are basically like directories.

Containers can have any name that you choose and are stored within your account. Accounts are named after your Brightbox account identifier (e.g: `acc-xxxxx`).

Orbit urls look like this:

`https://orbit.brightbox.com/{api-version}/{account-identifier}/{container-name}/{object-name}`

You can store and retrieve data using the OpenStack Swift compatible HTTP API, or using our SFTP service.

Our Image Library uses Orbit to store [Cloud Server](/docs/reference/cloud-servers/) and [Cloud SQL instance](/docs/reference/cloud-sql/) snapshots. They're available from the [special `images` container](/docs/reference/orbit/images-container/) in each account.

### Authentication

You can authenticate with Orbit using your Brightbox username and password, or an [API Client](/docs/reference/api-clients/) identifier and secret. If you're integrating another system with Orbit it's recommended to use an API Client, rather than have your system be authenticating as you.

API Clients in <q>Orbit Storage Only</q> privilege mode can only be used with the Orbit API and will be denied access to other resources (such as Cloud Servers, Load Balancers etc). Orbit-only API Clients can access no Orbit containers by default and must be explicitly granted read or write access.

Orbit-only API Clients can only manage objects and cannot list, create or modify containers themselves.

### API

Orbit provides an OpenStack Swift API, for which there are many compatible libraries and tools such as:

* [OpenStack Swift Python client bindings](http://docs.openstack.org/developer/python-swiftclient/swiftclient.html)
* Our very own Ruby interface, Fog
* [Duplicity](http://duplicity.nongnu.org/), the encrypted bandwidth-efficient rsync-like backup system
* [Several JAVA tools](http://javaswift.org/)
* [GO Language interface](https://github.com/ncw/swift)
* [php-opencloud](https://github.com/rackspace/php-opencloud)
* Python's [libcloud](http://libcloud.apache.org/)
* [Swiftly](https://github.com/gholt/swiftly) is another python command line interface for Swift

### SSH File Transfer Protocol

We provide an SFTP service for use with Orbit. You can read and write objects using any SFTP-compatible client, such as [Cyberduck](https://cyberduck.io/), [WinSCP](http://winscp.net), or just the standard `sftp` command line tool.

Just connect to `sftp.orbit.brightbox.com` using your Brightbox email address and password, or your API client and secret.

    #!shell
    $ sftp john@example.com@sftp.orbit.brightbox.com
    john@example.com@sftp.orbit.brightbox.com's password: 
    Connected to sftp.orbit.brightbox.com.
    sftp> ls
    container1
    container2
    images

If you are a collaborator on multiple accounts, then you can specify the account by adding the account identifier to the end of the username, separated with a colon:

    #!shell
    $ sftp john@example.com:acc-xxxxx@sftp.orbit.brightbox.com


### Guides

* [Using Orbit with the swift cli tool](/docs/guides/orbit/swift-cli/)
* [Accessing Orbit via HTTP using curl](/docs/guides/orbit/curl/).
* [Using Orbit with the CarrierWave gem](/docs/guides/orbit/carrierwave/)
* [Accessing Orbit using SSH file transfer protocol](/docs/guides/orbit/sftp/)
* [Orbit Container Access Control](/docs/guides/orbit/container-access-control/)

### Billing

Orbit is charged per gigabyte of storage used per month, and per gigabyte of data transferred out to the Internet. Incoming data and incoming or outgoing data from/to Brightbox Cloud servers is free
