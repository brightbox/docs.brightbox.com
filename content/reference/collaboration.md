---
layout: default
title: Collaboration
section: Reference
---

Collaboration allows an owner to grant other users access to their Brightbox Cloud account.

When you sign up normally to Brightbox Cloud, a user is created for you, and an [account](/reference/accounts) is created to hold your resources and billing details. Your user becomes the owner of the new account.

A collaborator on an account can do everything an owner can do except access the billing details. So they can create, modify and destroy any resource, including [images](http://docs.brightbox.com/reference/server-images/). They can also invite other collaborators to the account.

### Managing Collaborators

You can manage collaborators in either the [Brightbox Manager](/guides/manager/) or via the [Command Line Interface](/guides/cli/) (in version 1.1 or above). You can of course manage them [using our API](/reference/api/) directly.

To invite a collaborator you provide their email address and they are sent an email which includes a link to accept the invitation. If they are not already registered with Brightbox Cloud then they are invited to sign up.

Collaborators are not required to sign up for a full account so do not have to provide billing details etc.

### SSH Keys

If the collaborator has a public SSH key set, then it is included in the [metadata](/reference/metadata-service/) for new servers. That means that in most cases, the SSH keys of all collaborators will be installed on all new servers built on the account.

It's important to note that the installation of SSH keys only affects *new* servers, to grant initial access for bootstrapping. Removing a collaborator from an account does not automatically remove their SSH key from existing servers. Similarly, when you add a new collaborator their SSH key is not automatically installed on existing servers.

