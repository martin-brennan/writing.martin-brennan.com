---
id: 573
title: 'LINK: AngularJS Styleguide by @john_papa'
date: 2015-01-29T07:07:13+10:00
author: Martin Brennan
layout: post
guid: http://www.martin-brennan.com/?p=573
permalink: /link-angularjs-styleguide-john_papa/
dsq_thread_id:
  - 3465041333
mashsb_shares:
  - 0
mashsb_timestamp:
  - 1464919891
mashsb_jsonshares:
  - '{"total":0}'
categories:
  - Development
tags:
  - angular
  - angularjs
  - Javascript
  - styleguide
---
This AngularJS styleguide, written by <a title="john_papa" href="https://twitter.com/john_papa" target="_blank">@john_papa</a>, has been a fantastic resource for me while learning Angular:

<a title="AngularJS Styleguide" href="https://github.com/johnpapa/angularjs-styleguide" target="_blank">https://github.com/johnpapa/angularjs-styleguide</a>

Among the key takeaways in style that I found most important were the following:

  1. Wrap all angular components, factories, controllers, and directives in an Immediately Invoked Function Expression (IIFE). This is to prevent variables and functions polluting the global namespace.
  2. Use named functions instead of anonymous functions to help with debugging (generally a good idea for all JavaScript)
  3. Use the ControllerAs syntax to get access to `this` from the controller instead of using `$scope`. This is to avoid the &#8220;dot problem&#8221; in the views. It is also a good idea to assign this to a consistent variable such as VM to avoid `this` scoping issues.
  4. Use `$inject` to list all dependencies in an array for the component to prevent minification mangling, and huge function declarations including dependencies can be hard to read.

The whole document is a great read though and I really encourage you to read it if you are working on an Angular project.