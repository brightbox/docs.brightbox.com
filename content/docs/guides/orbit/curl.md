---
layout: default
title: Using Orbit with Curl
section: Guides
---

Our [Orbit](/docs/reference/orbit) storage service provides an OpenStack Swift API, for which there are many compatible libraries and tools, but you can control it using any standard http client, such as `curl`.

First, you need to authenticate and get a token. You can use either your Brightbox username and password, or (preferably) an [API Client](/docs/reference/api-clients/) identifier and secret. Obviously use your account identifier instead of `acc-xxxxx`:


    curl -I -H "x-auth-user: john@example.com" -H "x-auth-key: mypassword" https://orbit.brightbox.com/v1/acc-xxxxx
    
    HTTP/1.1 200 OK
    X-Storage-Url: https://orbit.brightbox.com/v1/acc-xxxxx
    X-Storage-Token: a586756da259f4c5699a92ebaa359b8e
    X-Auth-Token: a586756da259f4c5699a92ebaa359b8e

So here we've been given the token `a586756da259f4c5699a92ebaa359b8e`, which is valid for a couple of hours. We can now use that to read and write containers and objects by setting it as a http header named `x-auth-token`.

### Creating and listing containers

Every account has an `images` container that is used to store Cloud Server and Cloud SQL instance snapshots, but you can create your own containers to store your own objects like this:

    curl -I -X PUT -H "x-auth-token: a586756da259f4c5699a92ebaa359b8e" https://orbit.brightbox.com/v1/acc-xxxxx/avatars

	HTTP/1.1 201 Created

You can get a list of all the containers on your account like this:

    curl -H "x-auth-token: a586756da259f4c5699a92ebaa359b8e" https://orbit.brightbox.com/v1/acc-xxxxx
    
    images
    avatars

### JSON

You can get the responses in json format for easier parsing:

    curl -H "x-auth-token: a586756da259f4c5699a92ebaa359b8e" https://orbit.brightbox.com/v1/acc-xxxxx?format=json

    [
       {
          "bytes" : 33396,
          "count" : 1,
          "name" : "avatars"
       },
       {
          "name" : "images",
          "bytes" : 0,
          "count" : 0
       },
    ]

### Uploading an object

Uploading a new object is just a matter of making a HTTP PUT request with the object data as the body. Curl let's you specify a local file to upload with the `-T` option. It's good practise to specify a content type, though not necessary:

    curl -I -T jason.jpg -X PUT -H "x-auth-token: a586756da259f4c5699a92ebaa359b8e" -H "Content-Type: image/jpeg" https://orbit.brightbox.com/v1/acc-xxxxx/avatars/jason.jpg
    
    HTTP/1.1 201 Created
    Last-Modified: Thu, 24 Jul 2014 14:13:35 GMT
    Etag: 7e880ef4c52a4c0f2755983b55a3942f

### Downloading an object

As easy as making a GET request:
    
    curl -I -H "x-auth-token: a586756da259f4c5699a92ebaa359b8e" https://orbit.brightbox.com/v1/acc-xxxxx/avatars/jason.jpg
    HTTP/1.1 200 OK
    Content-Length: 33396
    Last-Modified: Thu, 24 Jul 2014 14:17:21 GMT
    Etag: 7e880ef4c52a4c0f2755983b55a3942f
    Content-Type: image/jpeg

#### Access control

You can open up any container to allow unauthenticated, public access to your objects by setting a read access control list like this:

    curl -I -X PUT -H "x-auth-token: a586756da259f4c5699a92ebaa359b8e" -H "x-container-read: .r:*" https://orbit.brightbox.com/v1/acc-xxxxx/avatars
     
    HTTP/1.1 204 No Content
    Date: Thu, 24 Jul 2014 14:10:51 GMT

And then you can get objects from that container without a token:

    curl -I https://orbit.brightbox.com/v1/acc-xxxxx/avatars/jason.jpg
	
    HTTP/1.1 200 OK
    Content-Length: 33396
    Last-Modified: Thu, 24 Jul 2014 14:17:21 GMT
    Etag: 7e880ef4c52a4c0f2755983b55a3942f
    Content-Type: image/jpeg

Set some cache headers for your object to allow it to be cached by browsers, or perhaps a CDN:

    curl -I -H "Cache-Control: public,max-age=86400" https://orbit.brightbox.com/v1/acc-xxxxx/avatars/jason.jpg
    
    HTTP/1.1 202 Accepted
    Date: Thu, 24 Jul 2014 14:29:44 GMT

	curl -I https://orbit.brightbox.com/v1/acc-jd6b8/avatars/jim-jones.jpg

	HTTP/1.1 200 OK
	Content-Length: 33396
	Last-Modified: Thu, 24 Jul 2014 14:29:45 GMT
	Etag: 7e880ef4c52a4c0f2755983b55a3942f
	Cache-Control: public,max-age=86400
	Content-Type: image/jpeg


