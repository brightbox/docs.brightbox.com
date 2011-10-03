---
layout: default
title: API Clients
section: Reference
---

An API Client is a set of credentials for accessing the API. It's composed of a client identifier (like `cli-xxxxx`) and a randomly generated secret.

API Clients are associated with Accounts, so once authenticated with a given API Client you can manage all the services on that Account.

An API Client id and secret are used to obtain a token, which is then use for authentication. Tokens are valid for 2 hours and are not revoked when an API Client is deleted.

You can create and manage API Clients using the [Brightbox Manager](/guides/manager/api-clients/), and of course via the [API itself](https://api.gb1.brightbox.com/1.0/#api_client).
