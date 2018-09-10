---
id: 698
title: Duration Parsing Using Juration
date: 2015-07-19T14:15:59+10:00
author: Martin Brennan
layout: post
guid: http://www.martin-brennan.com/?p=698
permalink: /duration-parsing-using-juration/
mashsb_timestamp:
  - 1464919823
mashsb_shares:
  - 0
mashsb_jsonshares:
  - '{"total":0}'
dsq_thread_id:
  - 3948324658
categories:
  - Development
tags:
  - date
  - duration
  - Javascript
  - juration
  - parsing
---
I’ve been working a lot with appointments and calendaring lately, and one of the requirements to create a new appointment was to have a duration parsing input that was easy to use. One that would let the user input combinations like `1h 10m` or `3h` or `25mins`. It didn’t take me long to find [Juration](https://github.com/domchristie/juration).

It’s a simple little library, only 2.6kb minified that does one thing and does it well, and it was exactly what I needed. For the string inputs, juration will return the equivalent number of seconds, which you can then determine the hours, minutes and seconds from. For example:

```javascript
juration.parse('1h 30m');
// 5400
```

Juration also works the other way, you can give it a number of seconds and a formatting option and it will output the string representation, for example:

```javascript
juration.stringify(5400, { format: 'long' });
// 1 hour 30 minutes
```

Juration parses anything from seconds up to years and is a simple, elegant solution for parsing duration inputs.
