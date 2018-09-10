---
id: 322
title: Callback Hell
date: 2013-03-18T20:45:45+10:00
author: Martin Brennan
layout: post
guid: http://www.martin-brennan.com/?p=322
permalink: /callback-hell/
iconcategory:
  - Share
dsq_thread_id:
  - 1188674306
mashsb_shares:
  - 0
mashsb_timestamp:
  - 1464920065
mashsb_jsonshares:
  - '{"total":0}'
categories:
  - Development
  - Share
---

{% include deprecated.html message="With the advent of ES6, Promises and the upcoming async/await, callback hell is nowhere near the big deal that it used to be." cssclass="deprecated" %}

If you&#8217;ve ever written any Javascript that contacts or lives on the server, you&#8217;ve probably experienced [Callback Hell](http://callbackhell.com/) by now. It is a horrible affliction that Javascript can suffer from as a result of many nested callback functions that are triggered once a request has been completed. Often times, this results in a whole bunch of anonymous functions that make your Javascript nested 2^84 levels deep which causes a lot of messiness and unreadability. There are a few simple ways you can avoid callback hell; you can read about them more in-depth with code examples by following the link but here is a good gist<!--more-->:

**Name your functions!** &#8211;Having named functions makes your code much easier to read and keep track of, especially when debugging or making changes!</span>

**Keep your code shallow!** &#8211; If your Javascript is indented more than about 3 levels, consider breaking it up further into smaller functions. This makes much more manageable chunks that are easier to test and maintain.

**Modularize!** &#8211; If you are using [nodejs](http://nodejs.org/) or [requirejs](http://requirejs.org/) you should be keeping related functionality in separate module files then `require`-ing them as they are needed. This makes the code easier to read and keep track of for other developers, and avoids polluting the global namespace.

Check out the [examples over at callback hell](http://callbackhell.com/) for more information, and hopefully you will be able to avoid the fiery depths!

**Edit:** In reply to Yussuf&#8217;s comment, you should also check out jQuery Promises for asynchronous AJAX requests in JavaScript. I have been making use of them extensively via Backbone.js and they are really useful. Here are a couple of handy articles on the subject:

  * [Wrangle Async Tasks With JQuery Promises - NetTuts+](http://net.tutsplus.com/tutorials/javascript-ajax/wrangle-async-tasks-with-jquery-promises/)
  * [What’s so great about JavaScript Promises? - Parse Blog](http://blog.parse.com/2013/01/29/whats-so-great-about-javascript-promises/)
