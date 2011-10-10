---
layout: default
title: DNS
section: Reference
---

Brightbox Cloud provides a number of dynamic dns records for convenience.

<table>
<tr>
<th>Record format</th>
<th>Response example</th>
<th>Description</th>
</tr>
<tr>
<td><code>srv-xxxxx.gb1.brightbox.com</code></td>
<td><code>10.240.119.222</code></td>
<td>Private IP address of each server</td>
</tr>
<tr>
<td><code>public.srv-xxxxx.gb1.brightbox.com</code></td>
<td><code>109.107.36.218</code></td>
<td>First Cloud IP mapped to the server. Returns NXDOMAIN is no Cloud IPs are mapped</td>
</tr>
</table>

## Reverse DNS

### Private Reverse DNS

Reverse dns for private addresses works from within Brightbox Cloud:

    $ host 10.240.119.222
    222.119.240.10.in-addr.arpa domain name pointer srv-su22m.gb1.brightbox.com.

### Cloud IP Reverse DNS

Reverse dns for Cloud IPs defaults to the form `cip-109-107-38-125.gb1.brightbox.com.`.

You can customize Cloud IP reverse dns using the api.  The forward dns mapping must be in place first otherwise the reverse dns update will be rejected.

Forward mappings for custom reverse dns are checked once a day and the account owner is sent an email notification if the forward mapping is found to be invalid.  If the forward mapping is left invalid for 3 consecutive days, the custom reverse dns mapping is removed and switches back to the default form.

The [CLI Reverse DNS guide](/guides/cli/reverse-dns/) will take you through setting up reverse dns step by step.