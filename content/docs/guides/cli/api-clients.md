---
layout: default
title: API Clients
section: CLI
---

This guide covers setting up the command line interface tool to use an [API client](/docs/reference/api-clients/) for authentication. API clients are better for automated systems - if you're a human, then you may prefer to use the standard username and password authentication covered in the [getting started guide](/docs/guides/cli/getting-started/). That guide also covers installing the command line interface tool.

### Create an Account and API Client

If you don't already have one, you'll first need to [sign up for a Brightbox Cloud Account](/docs/guides/getting-started/signup/)
using [Brightbox Manager](https://manage.brightbox.com/signup).

Once you've signed up, you now need to
[create an API Client](/docs/guides/manager/api-clients/) which you'll use
to configure the CLI below. An API Client is simply a pair of access
credentials for accessing the API, consisting of a client identifier
(like `cli-xxxxx`) and a secret.

### Configuration

You can now configure the CLI tool with the credentials for the API client you created.

To configure the CLI with these credentials, run the following
command:

    #!shell
    $ brightbox config client_add cli-xxxxx thesecretstring
		
    Using config file /home/john/.brightbox/config
    Creating new api client config cli-xxxxx


Now you can use the CLI tool to interact with Brightbox Cloud as usual. API client credentials never expire or need re-entering. They'll work until revoked by the account owner.

You now might want to try [building a server](/docs/guides/cli/getting-started/#building_your_first_server).

### Would you like to know more?

Here you installed and configured the Command Line Interface tool with
API client authentication.

You might want to learn about using the
Command Line Interface with your [Brightbox Cloud username and password](/docs/guides/cli/getting-started#create_an_account_and_oauth_application).
