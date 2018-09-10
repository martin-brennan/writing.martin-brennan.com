---
id: 411
title: Enable Gzip Compression in IIS
date: 2014-01-29T07:16:07+10:00
author: Martin Brennan
layout: post
guid: http://www.martin-brennan.com/?p=411
permalink: /enable-gzip-compression-in-iis/
iconcategory:
  - development
dsq_thread_id:
  - 2187514105
mashsb_shares:
  - 0
mashsb_timestamp:
  - 1465005348
mashsb_jsonshares:
  - '{"total":0}'
categories:
  - Development
  - Tutorial
tags:
  - gzip
  - iis
  - iis express
  - json
  - server
  - Windows
---

{% include deprecated.html message="This article is likely no longer relevent, follow the instructions at your own risk!" cssclass="deprecated" %}

For an API I am building, I needed to enable Gzip compression in IIS Express for JSON and came across [GZip response on IIS Express](http://stackoverflow.com/questions/10102743/gzip-response-on-iis-express).

There are just two commands to run. This example is for IIS Express but the same commands work in IIS:

```shell
cd %PROGRAMFILES%IIS Express
appcmd set config -section:urlCompression /doDynamicCompression:true
appcmd set config /section:staticContent /+[fileExtension='.json',mimeType='application/json']
appcmd.exe set config -section:system.webServer/httpCompression /+"dynamicTypes.[mimeType='application/json',enabled='True']" /commit:apphost
```

Then, restart IIS or IIS Express afterwards. Gzip compression is very beneficial, and it lowered response sizes for JSON API requests dramatically, sometimes by greater than 50%.
