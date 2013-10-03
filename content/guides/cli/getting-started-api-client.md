---
layout: default
title: Getting Started with API Clients
section: CLI
---

We have a lovely [browser-based GUI](/guides/manager/) for
managing your Brightbox Cloud resources, but sometimes the power of a
command line interface is desired.

You can interact with Brightbox Cloud using our our command line
interface tool, which uses our API. This guide will take you from
creating a Brightbox Cloud Account to logging into your first Cloud
Server via SSH.

### Create an Account and API Client

Firstly,
[sign up for a Brightbox Cloud Account](/guides/getting-started/signup/)
using [Brightbox Manager](https://manage.brightbox.com/signup).

Once you've signed up, you now need to
[create an API Client](/guides/manager/api-clients/) which you'll use
to configure the CLI below. An API Client is simply a pair of access
credentials for accessing the API, consisting of a client identifier
(like `cli-xxxxx`) and a secret.

### Initial setup

#### Installation

Now that you have an account and an API Client, you'll need to
[install the cli software](/guides/cli/installation/). Go do that and
come back here. I'll wait for you.

#### Configuration

You can now configure the CLI with the credentials for the API client
you created.

To configure the cli with these credentials, run the following
command:

    $ brightbox config client_add cli-xxxxx thesecretstring
		
    Using config file /home/john/.brightbox/config
    Creating new api client config cli-xxxxx

#### Initial test

You should be able to retrieve details of your user now. Note your id
as you'll need it in a moment:

    $ brightbox users list
    
     id         name        email_address         accounts
    -------------------------------------------------------
     usr-xxxxx  John Doe    john@example.com      1       
    -------------------------------------------------------

#### Configuring your ssh key

If you didn't provide a public ssh key when you signed up, you need to
do that now so that you can log into newly created servers:

    $ brightbox users update -f my-ssh-key.pub usr-xxxxx
               id: usr-xxxxx
             name: John Doe
    email_address: john@example.com
         accounts: acc-xxxxx
          ssh_key: ssh-dss AAAAB3....

### Building your first server

Now you're ready to
[build your first server](/guides/cli/getting-started/#building_your_first_server).


### Would you like to know more?

Here you installed and configured the Command Line Interface tool with
API client authentication.

You might want to learn about using the
Command Line Interface with your [Brightbox Cloud username and password](/guides/cli/getting-started#create_an_account_and_oauth_application).