---
layout: default
title: DNS
section: Reference
---

Brightbox Cloud provides a number of dynamic DNS records for convenience.

<table>
<tr>
<th>Record format</th>
<th>Response example</th>
<th>Description</th>
</tr>
<tr>
<td style="white-space:nowrap"><code>srv-xxxxx.gb1.brightbox.com</code></td>
<td><code>10.240.119.222</code></td>
<td>Private IPv4 address of the Cloud Server</td>
</tr>
<tr>
<td style="white-space:nowrap"><code>ipv6.srv-xxxxx.gb1.brightbox.com</code></td>
<td><code>2a02:1348:14c:250d:24:19ff:fef0:9436</code></td>
<td>IPv6 address of the Cloud Server</td>
</tr>
<tr>
<td style="white-space:nowrap"><code>public.srv-xxxxx.gb1.brightbox.com</code></td>
<td><code>109.107.36.218</code></td>
<td>First Cloud IP mapped to the Cloud Server. Returns NXDOMAIN if no Cloud IPs are mapped</td>
</tr>
<tr>
<td style="white-space:nowrap"><code>*.public.srv-xxxxx.gb1.brightbox.com</code></td>
<td><code>109.107.36.218</code></td>
<td>Wildcard alias for <code>public.srv-xxxxx.gb1.brightbix.com</code></td>
</tr>

<tr>
<td style="white-space:nowrap"><code>cip-xxxxx.gb1.brightbox.com</code></td>
<td><code>109.107.36.218</code></td>
<td>Public IPv4 address of the Cloud IP with the identifier <code>cip-xxxxx</code></td>
</tr>
<tr>
<td style="white-space:nowrap"><code>*.cip-xxxxx.gb1.brightbox.com</code></td>
<td><code>109.107.36.218</code></td>
<td>Wildcard alias for <code>cip-xxxxx.gb1.brightbox.com</code></td>
</tr>

</table>

### Reverse DNS

#### Private Reverse DNS

Reverse DNS for private addresses works from within the Brightbox Cloud network:

    $ host 10.240.119.222
    222.119.240.10.in-addr.arpa domain name pointer srv-su22m.gb1.brightbox.com.

#### Cloud IP Reverse DNS

Reverse DNS for Cloud IPs defaults to the form
`cip-109-107-38-125.gb1.brightbox.com.`

You can customise Cloud IP reverse DNS using the API.  The forward DNS
mapping must be in place first otherwise the reverse DNS update will
be rejected.

Forward mappings for custom reverse DNS are checked once a day and the
account owner is sent an email notification if the forward mapping is
found to be invalid.  If the forward mapping is left invalid for 3
consecutive days, the custom reverse DNS mapping is reset to the
default form.

The [CLI Reverse DNS guide](/docs/guides/cli/reverse-dns/) will take you
through setting up reverse DNS step by step.
