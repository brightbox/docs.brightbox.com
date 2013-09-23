---
layout: default
title: Network
section: Reference
---

Brightbox Cloud natively supports both IPv4 and IPv6.

Each [Cloud Server](/reference/glossary/#cloud_server) is on its own private VLAN and assigned a private IP address within its own `/30` network all within the `10.0.0.0/8` range. The Cloud Server has one IP, given to it by DHCP, and the other IP is used by the gateway.

The gateway IP is also a recursive DNS service, also advertised by DHCP.

### IPv6

Each Cloud Server is also assigned an IPv6 `/64`. Cloud Servers usually generate their own IPv6 address(es) from the advertised prefix using it's own MAC address, as per RFC 4862, though any IPv6 address within the given `/64` can be used.

Some images are configured by default to generate additional [temporary IPv6 address](http://en.wikipedia.org/wiki/IPv6_address#Temporary_addresses) for privacy reasons and will use these addresses randomly for outgoing connections.

### DNS

Convenient forward and reverse DNS records are provided for Cloud Server addresses. More details are available in the [DNS reference docs](/reference/dns/).

### Cloud IPs

Cloud IPs are public IP address that can be mapped onto Cloud Servers. More details are available in the [Cloud IP reference docs](/reference/cloud-ips/)

### Zones

Each [zone](/reference/glossary/#zone) is an independent Brightbox datacentre location with its own connectivity, so Cloud Servers in different zones may have slightly different paths to the Internet.

### Usage

Data to and from the Internet and between zones is [billed by the gigabyte](http://brightbox.com/pricing/#Data). Data sent between servers within the same zone is free of charge.

