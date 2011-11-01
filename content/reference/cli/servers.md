---
layout: default
title: CLI Server Management
---

## brightbox-servers create

The create command builds a new server from an image and boots it.

    $ brightbox-servers create [options] image_id

`image_id` is the identifier of the [image](/reference/glossary/#image) you'd like installed on the server.

`-n <string>, --name <string>`
: Friendly name for the server. Any string you like.

`-t <type_id>, --type <type_id>`
: The [type](/reference/glossary/#server_type) of server to build, such as `small` or `large`. Default is `nano`.

`-z <zone_id>, --zone <zone_id>`
: The [Zone](/reference/glossary/#zone) to create the server in. You can use the zone handle, such as `gb1-a` or the unique zone id, such as `zon-xxxxx`. If you don't specify a zone, one is automatically chosen for you.

`-i <number>, --server-count <number>`
: Number of servers to create. The cli currently just issues this many API create requests for you.

`-m <string>, --user-data <string>`
: Specify custom data that will be available to the server on boot via the [Metadata server](/reference/metadata-service/). The data is limited to 16k, and is base64 encoded before upload. If your data is already base64 encoded data, you can skip coding with the `--no_base64` option. See the [User Data Guide](/guides/cli/user-data/) for examples of how to use this.

`-f <filename>, --user-data-file <filename>`
: Specify a file containing the user data.

`-e, --no_base64`
: Tells the cli not to base64 user data provided with the `--user-data` or `--user-data-file` options. You must do your own base64 encoding or the data will be rejected by the server.

`-g, --server-groups`
: Comma separated list of [Server Groups](/reference/glossary/#server_group) that the newly created server should be a member of.
