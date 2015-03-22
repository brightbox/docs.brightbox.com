---
layout: default
title: OAuth Applications
section: Brightbox Manager
---

OAuth Applications are required to authenticate with the API with a username and password. OAuth Applications authenticate the device that you're using to communicate with the API. The Brightbox Manager uses it's own set of credentials, and you should generate an OAuth Application for each installation of the [command line interface](/docs/guides/cli/).

Creating a OAuth Application for each device allows you to revoke access to a single device without having to reset your username and password on all of your devices.

### Creating OAuth Applications

To create an OAuth Application, click on your Avitar to open the <q>User Menu</q> within the Brightbox Manager and then click the <q>OAuth Applications</q> option.

![](/images/docs/manage-user-applications.png)

Then click <q>Add New OAuth Application</q>. Choose a name for you to identify the OAuth Application and click <q>Save</q>.

![](/images/docs/manage-new-user-application.png)

You're then shown the new OAuth Application identifier and randomly generated secret.  The secret is shown at the top in the coloured bar and isn't stored - so you must note it down here before you leave the page.

![](/images/docs/manage-new-user-application-created.png)

If you lose this secret you cannot recover it, but you can generate a new one by clicking <q>Edit</q> and the <q>Regenerate secret</q>.

### Deleting OAuth Applications

To delete an OAuth Application, just click <q>Delete</q> button in the OAuth Application list.

Due to the way OAuth authentication works, any sessions authenticated before you deleted an OAuth Application can be valid for up to 2 hours.
