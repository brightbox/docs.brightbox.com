---
layout: default
title: Managing API Clients
section: Brightbox Manager
---

An [API Client](/docs/reference/api-clients) can be used to provide API access to a single account.
API Clients are most useful when writing scripts, such as when you're writing [Fog](/docs/guides/ruby/fog/) scripts or automating use of the [command line interface](/docs/guides/cli/).

You can create multiple API Clients, which allows you to selectively revoke access at a later date. For example, you might allocate an API Client for each script you create.

### Generating API Clients

To generate a new API Client, click the settings button (the cog) in the sidebar and then the <q>API Access</q> link from the dropdown.

![](/images/docs/manage-api-clients.png)

Then click <q>Add New API Client</q>. Choose a name for you to identify the API Client and click <q>Save</q>.

![](/images/docs/manage-new-api-client.png)

You're then shown the new API Client ID and randomly generated secret.  The secret is shown at the top in the coloured bar and isn't stored - so you must note it down here before you leave the page.

![](/images/docs/manage-api-client-created.png)

If you lose this secret you cannot recover it, but you can generate a new one by clicking the <q>Regenerate secret</q> button.

### Deleting API Clients

To delete an API client, just click <q>Delete</q> button in the API Clients list.

Due to the way OAuth authentication works, any sessions authenticated before you deleted an API Client can be valid for up to 2 hours.
