---
title: Getting nodejs file permissions from fs.stat mode
date: 2018-06-30T14:35:00+10:00
author: Martin Brennan
layout: post
permalink: /nodejs-file-permissions-fstat/
---

When you need to get file stats using NodeJS (which calls the unix `stat` command in the background), you can use the [`fs.stat`](https://nodejs.org/api/fs.html#fs_fs_stat_path_options_callback) call as shown below:

```js
fs.stat('path/to/file', function (err, stats) {
});
```

The `stats` object returned here is an instance of [`fs.Stats`](https://nodejs.org/api/fs.html#fs_class_fs_stats) which contains a `mode` property. You can use this property to determine the unix file permissions for the file path provided. The only problem is that this `mode` property just gives you a number (as referenced in [this GitHub issue](https://github.com/nodejs/node-v0.x-archive/issues/3045)). To view the permissions in the standard unix octal format (e.g. 0445, 0777 etc) you can use the following code:

```js
var unixFilePermissions = '0' + (stats.mode & parseInt('777', 8)).toString(8);
```

Some examples of the `mode` before and after calling the above snippet:

```
33188 -> 0644
33261 -> 0755
```