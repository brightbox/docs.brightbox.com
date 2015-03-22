---
title: Ubuntu on Brightbox Cloud
author: John Leach
tags: [ubuntu, ruby, packages, cloud, deployment]
---

Brightbox are a [Ubuntu Certified Cloud partner](/blog/2014/07/16/ubuntu-certified-cloud/) so the Ubuntu distro is ver well supported on Brightbox Cloud.

### Weekly and Daily Ubuntu image builds

Weekly builds of current Ubuntu images and daily builds of the Ubuntu testing image are provided. Our weekly images are automatically registered by our build systems, built directly from Ubuntu's own package repositories.

[This blog post](/blog/2012/05/31/weekly-ubuntu-image-builds/) goes into more detail about how it works.

### Ubuntu Ruby packages

A lot of our systems are developed in Ruby and we've been [maintaining up-to-date Ruby packages for Ubuntu](/docs/ruby/ubuntu/) for years. These packages make deploying Ruby apps on Ubuntu much easier.

### Ubuntu cloud-init support

Our Ubuntu images are pre-built with [cloud-init](/docs/guides/cloud-init), a tool to help you auto-configure new Ubuntu servers at boot time [using our user data service](/docs/guides/cli/user-data/#ubuntu-cloud-init-support). It works out-of-the-box on Brightbox Cloud.

### Command Line Interface on Ubuntu

Our CLI, for interacting with our API from the command line, is fully supported on Ubuntu. We [maintain packages](/docs/guides/cli/installation-ubuntu/) for it to make it very easy to get started.

