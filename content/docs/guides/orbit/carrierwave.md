---
layout: default
title: "Using Carrierwave with Brightbox Orbit"
section: Guides
---

This tutorial covers setting up and configuring a Rails application with
[CarrierWave](https://github.com/carrierwaveuploader/carrierwave) using
Brightbox's storage service [Orbit](/cloud/storage).

### What is CarrierWave?

CarrierWave allows you to upload files from Ruby applications to a number of
backing stores. Since it uses [fog](https://github.com/fog/fog) that means you can
use [Brightbox Orbit](/docs/reference/orbit/) as well.

### Create a simple Rails application

First off you need a simple Rails application, so create one like this:

    rails mynewapp

Next you need to add both `carrierwave` and `fog` dependencies to your
application by adding the following lines to the `Gemfile`:

    gem "carrierwave"
    gem "fog"
    gem "fog-brightbox", "~> 0.4.1"

Please note that CarrierWave detects if `fog` is available so if you use the
standalone `fog-brightbox` you will get an error. You also require a version of
`fog-brightbox` newer than `0.4.1` when storage support was added.

Next make sure the gems are installed:

    bundle install

Now you can configure your application.

### Configuring your application

Your application needs some credentials to identify itself, so go to
[Brightbox Manager](https://manage.brightbox.com) and create
a [new API client](/docs/guides/manager/api-clients/) for it.

You will need the client identifier and the secret (which is shown only once when
created or regenerated).

Add the credentials to an initializer by creating a new file within the project
called `config/initializers/carrerwave.rb` with the following content:

    CarrierWave.configure do |config|
      config.fog_credentials = {
        :provider => "Brightbox",
        :brightbox_client_id => "cli-12345",
        :brightbox_secret => "clientsecret"
      }
      config.fog_directory = "my_container"
    end

Obviously replace the example settings with your own :)

The Orbit container specified in `fog_directory` must exist before you
try to upload any files otherwise you get 404 errors. You can create
Orbit containers using the Brightbox Manager.

### Creating an uploader

You need to generate an uploader that uses the new fog configuration. So
generate it with:

    rails generate uploader Avatar

Now edit `app/uploaders/avatar_uploader.rb` to update our `AvatarUploader`
to use `fog` as its store.

You don't need much more than the following:

    class AvatarUploader < CarrierWave::Uploader::Base
      storage :fog
    end

This gives you a new class (for uploading user avatars) that will use
your API client to upload files to Orbit.

### Testing it works

Fire up a Rails console and try the following:

    > file = File.open "/Users/paul/Downloads/Avatar.jpg"
    => #<File:/Users/paul/Downloads/Avatar.jpg>
    > uploader = AvatarUploader.new
    => #<AvatarUploader:0x007fbf30d7d5d8 @model=nil, @mounted_as=nil>
    > uploader.store!(file)
    => [:store_versions!]

And you should have now uploaded a local file to your Orbit container!

Now use the `swift` CLI tool to just check it uploaded.

    $ swift -A https://orbit.brightbox.com/v1/acc-12345 -U cli-12345 -K clientsecret list my_container
    uploads/Avatar.jpg

You can refer to the [Using Orbit with the Swift CLI](/docs/guides/orbit/swift-cli)
guide for more detail on using the CLI.

### Building on

That covers the only real difference when configuring and using
Brightbox Orbit compared to other CarrierWave stores. Now you should
be able to follow along with
[the standard CarrierWave documentation](https://github.com/carrierwaveuploader/carrierwave)
to mount uploaders to your models etc.

Depending on what you want to do with your application, you may want
to restrict the types of files that can be uploaded. You should also
consider configuring appropriate
[access controls](/docs/guides/orbit/container-access-control/), so
your Rails application is limited to accessing only that one Orbit
Container.

And remember that you can also make your container public and serve
your uploads directly from Orbit.
