---
layout: default
title: CLI Server Management
---

## brightbox-servers create

The create command builds a new server from an image and boots it.

    $ brightbox-servers create [options] image_id

`image_id` is the identifier of the image you'd like installed on the server.

`-n <string>, --name <string>`
: Friendly name for the server. Any string you like.

`-t <type_id>, --type <type_id>`
: The type of server to build, such as small or large. Default is nano.

`-z <zone_id>, --zone <zone_id>`
: The zone to create the server in. You can use the zone handle, such as gb1-a or the unique zone id, such as zon-xxxxx. If you don't specify a zone, one is automatically chosen by the server.

`-i <number>, --server-count <number>`
: Number of servers to create. The cli currently just makes this many create requests.

`-m <string>, --user_data <string>`
: Specify custom data that will be available to the server on boot via the Metadata server. The data is limited to 16k, and is base64 encoded before upload. If your data is already base64 encoded data, you can skip coding with the –no_base64 option. See the user_data guide for examples of how to use this.

`-f <filename>, --user_data_file <filename>`
: Specify a file containing the user data.

`-e, --no_base64`
: Tells the cli not to base64 user data provided with the user_data or user_data_file options. You must do your own base64 encoding or the data will be rejected by the server.
