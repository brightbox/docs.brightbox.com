---
layout: default
title: API Authentication
---

The Brightbox API implements OAuth 2.0 so authentication is
implemented as an "Autonomous client" as described in version 10 of
the the
[OAuth2.0 specification](http://tools.ietf.org/html/draft-ietf-oauth-v2-10).

Requests to the API are authenticated using an API client, which
consists of an identifier, like `cli-xxxxx`, and a secret.  An API
client can control all resources on the account it belongs to.  An
account can have multiple API clients, but an API client only ever
belongs to one account.

The API client credentials are used to obtain an access token which
can then be used to authenticate API requests.

Access tokens are valid for 2 hours. Revoking an API client does not
revoke currently live tokens.

The
[API documentation](https://api.gb1.brightbox.com/1.0/#authentication)
describes authentication in more detail.
