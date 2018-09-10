---
id: 502
title: Run shell commands from Ruby
date: 2014-09-05T22:00:09+10:00
author: Martin Brennan
layout: post
guid: http://www.martin-brennan.com/?p=502
permalink: /run-shell-commands-from-ruby/
dsq_thread_id:
  - 3044736686
mashsb_shares:
  - 0
mashsb_timestamp:
  - 1464919954
mashsb_jsonshares:
  - '{"total":0}'
categories:
  - Development
tags:
  - Ruby
---
Just a quick tip, you can run shell commands from Ruby using the following syntax:

```ruby
%x(git log)
# or
system('git log')
```
