---
layout: default
title: Metadata Service
---

The metadata service is accessible from each cloud server and provides
metadata via http. It provides a few basic data, such as hostname,
instance-id and ssh keys, but can also provide custom user data.

The interface is compatible with the Amazon EC2 metadata service. It's
accessible from each server at http://169.254.169.254.


### Example usage

    $ curl http://169.254.169.254/latest/meta-data/
    hostname
    instance-id
    instance-type
    local-hostname
    local-ipv4
    placement/
    
    $ curl http://169.254.169.254/latest/meta-data/instance-id
    srv-sz59

See the [user data guide](/guides/cli/user-data/) for more
examples of using the meta data service.
