---
layout: default
title: API Clients
section: Reference
---

An API Client is a set of credentials for accessing the [Brightbox Cloud API](/docs/reference/api/). It's composed of a client identifier (like `cli-xxxxx`) and a randomly generated secret.

API Clients are associated with [Accounts](/docs/reference/accounts/), so once authenticated with a given API Client you can manage all the services on that Account.

An API Client id and secret are used to obtain a token, which is then use for authentication. Tokens are valid for 2 hours and are not revoked when an API Client is deleted.

You can create and manage API Clients using the [Brightbox Manager](/docs/guides/manager/api-clients/), and of course via the [API itself](https://api.gb1.brightbox.com/1.0/#api_client).

### Privileges

There are two types of API client privileges, <q>Full</q> and <q>Orbit Storage Only</q>.

#### Full

An API Client with <q>Full</q> privileges can access and manage all resources on the account, including managing other API clients and full read-write access to all [Orbit storage containers](/docs/reference/orbit).

#### Orbit Storage Only

An API Client with <q>Orbit Storage Only</q> privileges can only be used with the [Orbit Storage System](/docs/reference/orbit) API. Orbit API Clients cannot be used to manage or access any other resources (such as Cloud Servers, Load Balancers etc.).

Orbit API Clients must be given specific read or write access to individual Orbit containers, and are limited to accessing only objects. They cannot be used to create or modify containers, which instead must be done using an API Client with <q>Full</q> privileges.


