---
id: 755
title: gulp.watch High CPU Usage
date: 2016-03-30T13:55:26+10:00
author: Martin Brennan
layout: post
guid: http://www.martin-brennan.com/?p=755
permalink: /gulp-watch-high-cpu-usage/
mashsb_timestamp:
  - 1464977274
mashsb_shares:
  - 0
mashsb_jsonshares:
  - '{"total":0}'
dsq_thread_id:
  - 4704449882
categories:
  - Development
tags:
  - CPU
  - gulp
  - Javascript
  - node
  - nodejs
  - performance
  - watch
---
I noticed frequent slowdowns on my new work PC with Windows 10, an i7 and 16GB of RAM, and opened up Task Manager to see what could possibly have been slowing everything down. To my surprise, I found that the node process was hogging between 25 and 50 percent of CPU while it was running. <!--more-->When developing our frontend application, I run an Express server and several `gulp.watch` tasks to trigger a build whenever a .scss, .html or .js file in the project is changed. Here is ascreenshot of the process on the lower end of CPU utilization:

![node high cpu 1](/images/nodewatch1.png)


Since Express shouldn&#8217;t be taking up that many resources for our use case, I narrowed it down to `gulp.watch` high CPU usage. I looked around and [found this GitHub issue](https://github.com/gulpjs/gulp/issues/634) in which a user called shama suggested that the interval for the watch tasks should be set higher than the default of 100ms. I set mine to 750ms and the CPU usage dipped dramatically, from a constant 25-50% to a much lower 6-12% as demonstrated below:

![node high cpu 2](/images/nodewatch2.png)

The interval must be passed as the second argument to a watch task, and your gulp.watch high CPU usage woes should be banished!

    gulp.watch('src/**/*.js',  { interval: 750 }, function(event) {
      // watch code here
    }
