---
layout: default
title: CLI Configuration
section: Reference
---

Once you've created an OAuth Application id and secret, you can configure the cli with it like this:

    $ brightbox config user_add your@email-address app-xxxxx thesecretstring
    
    Using config file /Home/john/.brightbox/config
    Enter your password :
    Creating new client config your@email-address
    The default account of acc-12345 has been selected

Alternatively, you can still use an API client id and secret, like this:

    $ brightbox-config client_add cli-2igtb theclientsecret
    Using config file /home/ubuntu/.brightbox/config
    Creating new api client config cli-2igtb

