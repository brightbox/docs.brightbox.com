---
title: Getting started with Fog on Brightbox
layout: default
section: Ruby
tags: [fog, ruby, api, automation]
---

[Fog](http://fog.io) is a Ruby library that provides a common
interface to a number of different cloud providers. Fog allows Ruby
applications to control the Brightbox Cloud via our API. We use it as
the basis of our CLI tool so it will always be up to date with the
latest Brightbox goodness.

### Installing and Configuring Fog

You can install fog using:

    gem install fog

or via [bundler](http://gembundler.com/) by adding it to your
`Gemfile` and running `bundle`:

    gem "fog"

We'll need a Brightbox [API Client](/guides/manager/api-clients/) in
order to connect to the API. If you haven't
[signed up](https://manage.brightbox.com/user/new) and created an
[API Client](/guides/manager/api-clients/) yet you'll need to do that
now.

### Listing Images

Now that we have Fog installed and have our API Client we can create a
new connection. Let's create a script to list images and call it
`images.rb`.

    require 'fog'

    compute = Fog::Compute.new(
      :provider => :brightbox,
      :brightbox_client_id => "your_api_client_id",
      :brightbox_secret => "your_secret"
    )

Now we have our connection we can list all of the images, like so:

    compute.images.all

We can also find the details about a specific image using its
identifier, for example to get details about our
[Ubuntu Precise 12.04 LTS server](http://releases.ubuntu.com/precise/)
image:

    image = compute.images.get('img-l5pso')

Instead of having to add our client credentials to each script we
create we can put them in the Fog configuration file. So let's create a
new file at `~/.fog` and add the following:

    :default:
      :brightbox_client_id: "your_api_client_id"
      :brightbox_secret: "your_secret"

Now we can just create a new instance of compute with:

    compute = Fog::Compute.new(:provider => :brightbox)

### Creating a Server

Listing images is great but it's not going to help us launch our
super-awesome-auto-scaling new product. Let's get down to the real
power of Fog and start some servers.

Now that we know which image we want to launch let's go ahead and
create a server with that image:

    zone = compute.zones.first
    compute.servers.create(:zone_id => zone.id, :image_id => 'img-l5pso')

If we don't specify any image or other details, Fog will create a `nano`
server type instance with Ubuntu Precise 12.04 server within zone `gb1-a`.

We can check the status of our server using:

    server.reload.state

Or we can wait until Fog determines that the server is ready:

    server.wait_for { ready? }

As soon as the server is ready the ruby script will
continue and we can start using our server.

Now let's add a Cloud IP to this server. We start by allocating a
Cloud IP and then we map it to the ID of our newly created server:

    cloud_ip = compute.cloud_ips.allocate
    cloud_ip.map(server)

It's also worth noting that we can snapshot a server and spawn
multiple copies of it later. We could, for example, create a worker
image and then just create more of them as demand for our app
grows. Simply find the server using its identifier.

    compute.servers.all
    server = compute.servers.get('srv-12345')
    snapshot = server.snapshot

Each snapshot is given an image identifier just like the standard
images. We can just pass that identifier into the create server
command and our snapshot will be launched as the basis of a new
server.

### Further options

Although this guide has just run through the basics of Fog we can use
it to control virtually every aspect of the Brightbox Cloud. In fact,
our CLI uses Fog underneath so anything that we can do in the CLI can
be programmatically achieved using Fog.

Check out the Fog source code at
[https://github.com/fog/fog]((https://github.com/fog/fog) for more
details. You can see that there are a list of models and each one can
be accessed in a pretty consistent manner.
