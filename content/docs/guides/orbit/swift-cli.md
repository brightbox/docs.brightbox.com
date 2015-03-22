---
layout: default
title: Using Orbit with the Swift CLI
section: Guides
---

Our storage service, [Orbit](/docs/reference/orbit), provides an OpenStack Swift API, for which there are many compatible libraries and tools, such as the official swift command line interface.

For authentication you can use either your Brightbox Cloud username and password, or (preferably) an [API Client](/docs/reference/api-clients/) identifier and secret. Obviously use your account identifier instead of `acc-xxxxx`:

### Check your account stats

    swift -A https://orbit.brightbox.com/v1/acc-xxxxx -U cli-yyyyy -K mysecret  stat
    
    Account: acc-xxxxx
    Containers: 3
       Objects: 45845
         Bytes: 93603164978

Or using your username and password

    swift -A https://orbit.brightbox.com/v1/acc-xxxxx -U jason@example.com -K mypassword stat
    
    Account: acc-xxxxx
    Containers: 3
       Objects: 45845
         Bytes: 93603164978

If you are a collaborator on other accounts, you can access them by specifying the other account identifier in the authentication url:

    swift -A https://orbit.brightbox.com/v1/acc-zzzzz -U jason@example.com -K mypassword stat
    
    Account: acc-zzzzz
    Containers: 37
       Objects: 945845
         Bytes: 25593603164978


### Upload a file

Upload a file to a new container:

    swift -A https://orbit.brightbox.com/v1/acc-xxxxx -U cli-yyyyy -K mysecret upload avatars jason.jpg

Then list the containers:

    swift -A https://orbit.brightbox.com/v1/acc-xxxxx -U cli-yyyyy -K mysecret list
    
    avatars

Then list the files in the new container:
    
    swift -A https://orbit.brightbox.com/v1/acc-xxxxx -U cli-yyyyy -K mysecret list avatars
    
    jason.jpg
 
### Access control

You can control access to containers using access control lists. For example, to make the objects in a container publicly readable:

    swift -A https://orbit.brightbox.com/v1/acc-xxxxx -U cli-yyyyy -K mysecret post avatars --read-acl='.r:*'

You can then access the objects via HTTP:

    curl -I https://orbit.brightbox.com/v1/acc-xxxxx/avatars/jason.jpg
    
    HTTP/1.1 200 OK
    Content-Length: 430307
    Content-Type: image/jpeg
    Accept-Ranges: bytes
    Last-Modified: Tue, 18 Mar 2014 00:03:39 GMT
    Etag: 1c37aa571827f7833e7a4a276fd33485

### Directory lisitings

You can enable public directory listings for a container like this:

    swift -A https://orbit.brightbox.com/v1/acc-xxxxx -U cli-yyyyy -K mysecret post avatars -m 'web-listings: true'

