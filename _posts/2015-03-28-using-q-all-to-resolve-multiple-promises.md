---
id: 637
title: Using $q.all() to Resolve Multiple Promises
date: 2015-03-28T09:55:12+10:00
author: Martin Brennan
layout: post
guid: http://www.martin-brennan.com/?p=637
permalink: /using-q-all-to-resolve-multiple-promises/
mashsb_shares:
  - 0
mashsb_timestamp:
  - 1465021503
mashsb_jsonshares:
  - '{"total":0}'
dsq_thread_id:
  - 3632983258
dsq_needs_sync:
  - 1
categories:
  - Development
tags:
  - $q
  - angular
  - Javascript
  - promises
---
If you have a lot of promises in Angular that need to be run sequentially, you can go about it in one of two ways. There is the classic way of chaining callback functions together to achieve the desired result. Or there is the better way, which uses $q.all(). <!--more--> Assume that all of the functions in the example below follow this format:

```javascript
function promiseX() {
    let deferred = $q.defer();

    ajaxCall().then((response) => {
        deferred.resolve(response);
    }, (error) => {
        deferred.reject(error);
    });

    return deferred.promise;
}
```

{% include in-post-ad.html %}

Consider the way of callback chaining your promise results.

```javascript
let values = [];
promiseAlpha().then((val1) => {
    values.push(val1);
    promiseBeta().then((val2) => {
        values.push(val2);
        promiseGamma().then((val3) => {
            values.push(val3);
            complete();
        });
    });
});
```

This, as you can see, is not very pretty at all, and will make it difficult to a) get the resolved value of each promise and use it and b) chain more than a few promises without pulling your hair right out of its sockets. Thankfully there is an alternative in the form of [$q.all()](https://docs.angularjs.org/api/ng/service/$q#all).

The `$q.all()` method takes either an object or an array of promises and waits for all of them to `resolve()` or one of them to `reject()` and then executes the provided callback function. The values returned from the resolve function are provided depending on the way you give the promises to `all()`.

If you provide them as an array, then the values will be available as an array with the same corresponding order of the promises array. For example:

```javascript
let promises = [promiseAlpha(), promiseBeta(), promiseGamma()];

$q.all(promises).then((values) => {
    console.log(values[0]); // value alpha
    console.log(values[1]); // value beta
    console.log(values[2]); // value gamma

    complete();
});
```

However if you provide an object literal to `all()`, the values are attached to an object with the same corresponding property names in the `all()` callback. I find this way a lot easier because in most (but not all) cases you will have a set number of promises to complete.

```javascript
let promises = {
    alpha: promiseAlpha(),
    beta: promiseBeta(),
    gamma: promiseGamma()
}
$q.all(promises).then((values) => {
    console.log(values.alpha); // value alpha
    console.log(values.beta); // value beta
    console.log(values.gamma); // value gamma

    complete();
});
```

This article comes out of a situation where I had to match values against ids from lists returned from an API, where the list data was not preloaded. As you can see, `$q.all()` becomes a very useful and much shorter way of chaining promise `resolve()`s than callback chaining.
