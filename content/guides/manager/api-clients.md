---
layout: default
title: Managing API Clients
section: Brightbox Manager
---

An API Client is required whenever you authenticate with the API, such as when you use the [command line interface](/guides/cli/).

You can create multiple API Clients, which allows you to selectively revoke access at a later date. For example, you might allocate an API Client for each member of your team.

### Generating API Clients

To generate a new API Client, click the "Accont & Billing" button in the sidebar and then the "API Access" tab at the top right.

![](/images/manage-api-clients.png)

Then click `Add New API Client`. Choose a name for you to identify the API Client and click `Save`.

![](/images/manage-new-api-client.png)

You're then shown the new API Client ID and randomly generated secret.  The secret is shown at the top in the coloured bar and isn't stored - so you must note it down here before you leave the page.

![](/images/manage-api-client-created.png)

If you lose this secret you cannot recover it, but you can generate a new one by clicking the `Regenerate secret` button.

### Deleting API Clients

To delete an API client, just click `Delete` button in the API Clients list.

Due to the way OAuth authentication works, any sessions authenticated before you deleted an API Client can be valid for up to 2 hours.
