---
layout: default
title: Orbit Container Access Control
section: Guides
---

Our durable object storage service, [Orbit](/docs/reference/orbit/), makes it easy to store many gigabytes or terrabytes of data securely, replicated across our two UK datacentres.

It frees you from having to think about scaling your storage capacity
so you can just write whatever size data you need, whenever you need to and just pay for what you use.

It also gives you control over how that data can be accessed by different users or applications.

### Containers

Orbit separates data within an account using containers. Containers are a bit like filesystem directories - they group together a set of objects and allow you to control access to them as a set.

### Authentication

There are two main types of Orbit authentication, User authentication and "API Client" authentication.

#### User authentication

Users are account owners or collaborators and can read and write to all Orbit containers on that account. User authentication is for trusted humans.

#### API clients

API Clients are credentials you can use to authenticate tools and applications, such as a web application storing avatars or a backup tool uploading backups.

So let's go through setting up an API Client for use with a backup tool that will be limited to accessing just one Orbit storage container.


### Create an API Client

<img src="/images/docs/orbit-api-access.png" alt="" class="doc-right doc-border"/>

Firstly, we need to create a new API Client. Log into [Brightbox Manager](/docs/guides/manager/). If you don't already have an account, you can [sign up here](https://manage.brightbox.com/signup) in a couple of minutes.

Click the cog icon at the top left of the page, next to your account name which will display the account menu. Then select the <q>API access</q> menu option.

This will display your account's API Clients list. Click the <q>New API Client</q> button.

<br class="clear"/>

#### Set the privileges

<img src="/images/docs/orbit-new-api-client.png" alt="" class="doc-right doc-border"/>

As this API Client is going to be used by our backups system, let's give it the name `backups`.

By default, API Clients have <q>Full</q> privileges, which gives them read and write access to all Orbit containers on that account (and to all other cloud resources too).

Here though, we want our backup system to only have access to the backups data, so we'll set the privileges for this API Client to <q>Orbit Storage Only</q>. This will limit the API Client to accessing only the Orbit API and limit it's access to specific containers we define.

<img src="/images/docs/orbit-api-client-orbit-only.png" alt="" class="doc-border"/>

When you click <q>Save</q>, a new API Client will be created with a new identifier, which will look something like `cli-hgtla` and a random secret which is displayed in the yellow box at the top. Note them both down (the random secret in particular cannot be displayed again, you'll have to regenerate it if you lose it).

<img src="/images/docs/orbit-api-client-secret.png" alt="" class="doc-border"/>

<br class="clear"/>

### Create the Orbit container

Now we need to create the container in Orbit. This can be done with Orbit's OpenStack Swift compatible API, but here we'll just use the Orbit Storage interface in Brightbox Manager (which uses that same API behind the scenes anyway).

In the main navigation bar on the left, click <q>Orbit Storage</q> button, which will bring up a list of your Orbit containers (if you have any).

Then click <q>New Container</q> to bring up the new container dialog. Let's give this container a name of `backups` - enter it into the name field.

<img src="/images/docs/orbit-new-container.png" alt="" class="doc-border"/>


#### Container permissions

Now we need to give the API Client permission to read and write to this container. So click the <q>Permissions</q> tab, and enter the API Client identifier into both the <q>Read permissions</q> and <q>Write permissions</q> boxes. You need to prefix the API Client identifier with your account identifier and a colon, so it looks something like like: `acc-aaaaa:cli-bbbbb`.

<img src="/images/docs/orbit-container-permissions.png" alt="" class="doc-border"/>

### Access the Orbit container

That's the Orbit side all done. The simplest way to test it is via our [SFTP](/docs/reference/orbit/#ssh-file-transfer-protocol) service. Just login using the API Client identifier as the username and the secret as the password.

You'll notice that you can't see any containers in the list, as the API Client doesn't have permission to list them. But you can still enter the backups container and upload data to it just fine:

    #!shell
    $ sftp cli-hgtla@sftp.orbit.brightbox.com
    
    cli-hgtla@sftp.orbit.brightbox.com's password:
    
    Connected to sftp.orbit.brightbox.com.
    
    sftp> ls
    
    sftp> cd backups
    
    sftp> put today.tar.gz
    Uploading today.tar.gz to /backups/today.tar.gz
    
    sftp> ls -l
    -rw-r--r--   1 0        0      7516192768 08 Jan 17:06 today.tar.gz

Now you just need to configure your chosen backup software. Some tools, such as [duplicity](http://duplicity.nongnu.org/), natively support the OpenStack Swift API but most others will at least happily integrate via SFTP.
