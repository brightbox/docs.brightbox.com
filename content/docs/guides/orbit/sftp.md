---
layout: default
title: Accessing Orbit using SSH file transfer protocol
tags: sftp, orbit
section: Guides
search: true
---

For convenience, we provide an  [SFTP](https://en.wikipedia.org/wiki/SSH_File_Transfer_Protocol) service for use with [Orbit](/docs/reference/orbit/), our object storage system.

SFTP is a file transfer protocol that runs over SSH, so all data is strongly encrypted in transit.

You can read and write objects using any SFTP-compatible client, such as [Cyberduck](https://cyberduck.io/), [WinSCP](http://winscp.net), or just the standard `sftp` command line tool.

Just connect to `sftp.orbit.brightbox.com` using your Brightbox email address and password, or your [API client](/docs/reference/api-clients/) identifier and secret.

    $ sftp john@example.com@sftp.orbit.brightbox.com
    john@example.com@sftp.orbit.brightbox.com's password: 
    Connected to sftp.orbit.brightbox.com.
	
    sftp> ls
    container1
    container2
    images

If you are a [collaborator](/docs/reference/collaboration/) on multiple accounts, then you can specify the account by adding the account identifier to the end of the username, separated with a colon:

    $ sftp john@example.com:acc-xxxxx@sftp.orbit.brightbox.com

SFTP gives you convenient access to data stored in Orbit, but if you're integrating Orbit into your system, we recommend that you use the [OpenStack Swift-compatible HTTP interface](/docs/reference/orbit/) rather than SFTP. The HTTP interface is higher performance and supports the full Orbit feature-set, such as managing metadata and configuring access control.
