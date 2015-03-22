---
layout: default
title: Orbit image storage
section: Reference
search: true
---

The Brightbox [Image Library](/docs/guides/cli/image-library/) uses [Orbit](/docs/reference/orbit/) to store [Cloud Server](/docs/reference/cloud-servers/) and [Cloud SQL instance](/docs/reference/cloud-sql/) snapshots. They're available from the `images` container in each account.

Cloud Server snapshots have the prefix with `img-` and Cloud SQL instance snapshots have the prefix `dbi-`.

The `images` container is read-only. Snapshots stored within it can only be deleted using the Brightbox API, or via the CLI or Brightbox Manager tools (which use the API). They can be downloaded using the standard Orbit access methods, such as HTTP or [SFTP](/docs/guides/orbit/sftp/).

