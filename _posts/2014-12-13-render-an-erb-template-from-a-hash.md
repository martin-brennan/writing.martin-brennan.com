---
id: 544
title: Render an ERB Template from a Hash
date: 2014-12-13T19:00:01+10:00
author: Martin Brennan
layout: post
guid: http://www.martin-brennan.com/?p=544
permalink: /render-an-erb-template-from-a-hash/
wp88_mc_campaign:
  - 1
dsq_thread_id:
  - 3319175788
mashsb_shares:
  - 0
mashsb_timestamp:
  - 1465019766
mashsb_jsonshares:
  - '{"total":0}'
categories:
  - Aha!
  - Development
tags:
  - erb
  - hash
  - Ruby
  - template
---
I needed to render an ERB template from a hash for external email templates, and found that this is not as straightforward as you might think. I found a blog post on splatoperator.com with a way to accomplish this. Basically, the hash needs to be converted into an OpenStruct before passing it to the ERB template.

[Render a template from a hash in Ruby (splatoperator.com)](http://splatoperator.com/2012/07/render-a-template-from-a-hash-in-ruby/)

The important part of the article and the code snippet demonstrating the functionality are below:

> You have to set the binding for ERB by saying opts.instance\_eval {binding}. This runs binding in the context of the opts object, so then calls to methods like first\_name made by ERB in this context will evaluate to the values of our hash.



This will of course result in &#8220;Hello Martin Brennan.&#8221;
