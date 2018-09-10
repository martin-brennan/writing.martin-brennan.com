---
title: The Fundamentals of Flow in 10-ish Minutes
date: 2017-01-08T09:30:00+10:00
author: Martin Brennan
layout: post
permalink: /fundamentals-of-flow-in-10-ish-minutes/
---

I'm still kind of undecided on the best way to add type checking into JavaScript. On the one hand there is [Typescript](https://www.typescriptlang.org/), which a lot of people seem to be going toward. It's a superset of JavaScript, and it adds a LOT of new language features, as well as compile-time type checking. It's backed by Microsoft, and has widespread support in other projects like [AngularJS](https://angular.io/). It's easy to add to an existing project, and having used it briefly myself the ecosystem behind it, including typing libraries for projects like Lodash and React, and the benefits it brings are outstanding, and I really feel like this will be the future of JavaScript.

On the other hand there is [Flow](https://flowtype.org/) which was created by Facebook. It's also a compile-time static type analysis tool, and like Typescript you can add it gradually to your project by adding `// @flow` to the top of .js files that you want to perform type checking on. Flow doesn't aim to add a lot of new language features like Typescript does, but rather it attempts to ensure correctness in your JavaScript code using the type analysis. Here's a good comparison article between the two if you want to do some further research [http://michalzalecki.com/typescript-vs-flow/](Typescript vs Flow).

I watched this video a little while back by Alex Booker ([@bookercodes](https://twitter.com/bookercodes)), a developer on Pusher, that serves as a great introduction to Flow. Check it out below, and there's a similar type of video on the Typescript website.

<div style="text-align:center">
<iframe width="560" height="315" src="https://www.youtube.com/embed/xWMuAUbXcdQ" frameborder="0" allowfullscreen></iframe>
</div>