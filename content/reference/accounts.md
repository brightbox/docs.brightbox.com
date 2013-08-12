---
layout: default
title: Accounts
---

When you sign up normally to Brightbox Cloud, a user is created for
you and an Account created to hold your resources and billing details.

It is possible to create multiple Accounts, for example, to manage
resources for your own separate customers. Each Account has one owner,
but can have multiple [collaborators](/reference/collaboration) who
can manage resources on it.

Accounts have a unique identifier of the form `acc-xxxxx`.

Each account has one associated credit card.

### Creating an account

To sign up with Brightbox Cloud,
[create a new account using Brightbox Manager](https://manage.brightbox.com/signup). This
will create a new account and an associated account owner.

### Account Limits

Each account has a number of default limits that restrict the amount
of resources that can be in use at once.

To view your limits and current usage, use the
[Brightbox Manager](/guides/manager/) and click "Account & Billing" in
the side bar and then "Account Limits".

You can request an increase of any limit by clicking the "Request
increase" button. Set the new limit that you'd like to request and
provide some details about why you need the increase.

### Closing your account

To close your account, ensure that all your resources have been
removed (destroy all Servers, Load Balancers and Machine Images and
un-allocate all Cloud IPs etc).

Then, as the owner of the account, use the
[Brightbox Manager](/guides/manager/) to make a
[Billing Support Request](/reference/billing/#support_request) and
request that your account should be closed.

A final invoice will usually be issued within seven days and your
account will be closed.

