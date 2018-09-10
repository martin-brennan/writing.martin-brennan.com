---
id: 562
title: LiveReload With Gulp
date: 2015-01-27T19:39:04+10:00
author: Martin Brennan
layout: post
guid: http://www.martin-brennan.com/?p=562
permalink: /livereload-gulp/
dsq_thread_id:
  - 3461865805
mashsb_shares:
  - 0
mashsb_timestamp:
  - 1465019116
mashsb_jsonshares:
  - '{"total":0}'
categories:
  - Development
tags:
  - angular
  - browser
  - gulp
  - Javascript
  - livereload
---
I&#8217;ve started working on a project to learn and use ES6 Modules, [Angular](http://angularjs.org), and [Gulp](http://gulpjs.com/), and one of the first issues I encountered was getting LiveReload to work, refreshing my browser every time I changed a file. For those not familiar with the concept, LiveReload works in one of three ways (from the [LiveReload FAQ](http://feedback.livereload.com/knowledgebase/articles/87979-how-do-i-choose-the-best-integration-method)):

> To communicate with your browsers, LiveReloads needs its JavaScript code to be injected into your web pages. There are 3 ways to arrange that:
>
>   * either add a script tag into your HTML code manually, or
>   * install a browser extension (that, when activated, adds the script tag to the visited pages on the fly), or
>   * use a plugin for your web framework (that adds the script tag on the fly when serving requests).

<!--more-->

To get it to work in my gulp workflow, I used the [gulp-webserver](https://github.com/schickling/gulp-webserver) plugin, which serves as a tiny server for the HTML you are serving for your application, to act as a local development environment. This server automatically sets up its own LiveReload functionality on a default or specified port, and then injects the JavaScript tag at the bottom of the page of every HTML file running on the server. You can see below for my gulp task that I use to set up the server:



This way, whenever any file in the directory is changed, LiveReload notifies the browser and the page refreshes. This, combined with other gulp tasks and build tools, makes working with single page applications and even normal HTML websites a lot quicker, especially if you have your browser on one monitor and your IDE on another. I tried using several other solutions including express with connect-livereload, but gulp-webserver was the plugin that worked the best!
