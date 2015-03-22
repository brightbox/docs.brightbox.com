---
layout: default
title: SSH Keys
section: Brightbox Manager
---

When a new server is built, it will attempt to install your ssh key on boot so you can log into it. If you didn't specify a public ssh key when you first signed up for Brightbox Cloud, you can add one easily enough now.

Click your user icon at the top right and the user menu will be displayed.

![](/images/docs/manage-ssh-key-menu-cropped.png)

Click <q>SSH Public Key</q>, which will show you your current key (or it'll be empty if you don't have one).

![](/images/docs/manage-ssh-public-key-viewer.png)

Click <q>Edit SSH Key</q> and paste your public ssh key into the text box. Then click <q>Save</q> to update it.

![](/images/docs/manage-ssh-key-pasted-cropped.png)

And you're done! Changing your ssh key only affects new servers built from then on - the updated key is not automatically distributed to existing servers. It's just for the initial bootstrap.

You can add more than one key here - just paste them all in together, one per line.

Most Brightbox Cloud [server images](/docs/reference/server-images/) support installing ssh keys on boot, but our Windows images require manually setting a password [using the console](/docs/guides/manager/graphical-console).
