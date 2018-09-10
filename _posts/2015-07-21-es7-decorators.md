---
id: 701
title: ES7 Decorators
date: 2015-07-21T22:18:06+10:00
author: Martin Brennan
layout: post
guid: http://www.martin-brennan.com/?p=701
permalink: /es7-decorators/
comments: true
mashsb_timestamp:
  - 1465017564
mashsb_shares:
  - 0
mashsb_jsonshares:
  - '{"total":0}'
dsq_thread_id:
  - 3955867361
categories:
  - Development
---
I read a fantastic article the other day by Addy Osmani, who among other things created [Yeoman](http://yeoman.io/), [TodoMVC](http://todomvc.com/), [Material Design Lite](https://github.com/google/material-design-lite), and who works at Google on Chrome and [Polymer](https://www.polymer-project.org/1.0/). The article was what we can expect from ES7 Decorators, which can be found below:

> [Exploring ES7 Decorators by Addy Osmani](https://medium.com/google-developers/exploring-es7-decorators-76ecb65fb841)

You should definitely read the article because it is a succinct and clear explanation of decorators and what you would use them for. They are available to use now in both [Babel](https://babeljs.io/), though not at the time of writing in Traceur. Generators along with other languages features like [async/await](http://jakearchibald.com/2014/es7-async-functions/), are major additions to JavaScript that should be coming along next year, so you should read up on them now! This article is just a quick summary of Addy&#8217;s with some different examples of what you can use decorators for.

You can check out the examples presented in this article in the [online Babel REPL](https://babeljs.io/repl/), as long as you check the &#8220;Experimental&#8221; checkbox. You can then run the generated result in something like [JSFiddle](https://jsfiddle.net/). <!--more-->

## So, what&#8217;s a decorator?

A decorator, put simply, is a function that can transparently wrap another function, class or property to provide extra functionality. Here&#8217;s what one might look like, from Addy&#8217;s article, a `readonly` decorator that prevents a class property from being overridden.

```javascript
// decorators.js
function readonly(target, key, descriptor) {
  descriptor.writable = false;
  return descriptor;
}

export default { readonly }

// person.js
import { readonly } from 'decorators';

class Martin {
  @readonly
  dateOfBirth = '1990-09-25';
}
```

The `@readonly` declaration above the `dateOfBirth` property is how you would use the decorator, which in this case I&#8217;ve defined in another file. Let&#8217;s have a look at what happens if we try and write to the property:

```javascript
let me = new Martin();
me.dateOfBirth = new Date();

// Exception: Attempted to assign to readonly property
```

You can see that you get `target`, `key` and `descriptor` method parameters in your decorator function. They each target different things and have their own properties:

  * `target` &#8211; The class that the decorator is used on.
  * `key` &#8211; If using the decorator on a property, this is the name of the property.
  * `descriptor` &#8211; Contains the properties `value`, `enumerable`, `configurable`, and `writable` for the property/function.

You can also define your decorator as a factory, so you can pass extra parameters into the decorator function. This can be used to do things like attach extra properties to a class. For example:

```javascript
function gang(name, location) {
  return function(target) {
    target.name = name;
    target.location = location;
  }
}

@gang('The Warriors', 'Coney Island');
class Group() {}

@gang('The Riffs', 'Gramercy Park');
class Group() {}

@gang('Turnbull ACs', 'Gunhill');
class Group() {}
```

## Thoughts

I don&#8217;t know about you but I&#8217;m getting really excited about using decorators. They remind me of [Attributes](https://msdn.microsoft.com/en-us/library/aa288454(v=vs.71).aspx) in C#, which I&#8217;ve used a lot before when writing REST APIs in .NET. I think they have massive potential in large frontend applications to tightly implement security functionality. For example, if you don&#8217;t want someone making certain API calls via the frontend (you should also apply the same rules on the API) you could do something like this:

```javascript
function adminOnly(user) {
  return function(target) {
    if (!user.isAdmin) {
      toast.error('You do not have sufficient privileges for this area!');
      return false;
    }
  }
}

@adminOnly(app.identity.currentUser)
function deleteAllUsers() {
  app.api.users.delete().then((response) =&gt; {
    toast.success('Yay you deleted everyone!');
  });
}
```

Granted this is an extremely basic example that skips around things like Dependency Injection (if you&#8217;re using Angular) or ES6 `import` statements. I&#8217;ll be writing an article where I explore how decorators can be used with Angular in the future. What&#8217;s more important is the recognition of the power that decorators bring to JavaScript, and that they are something you should be keeping an eye on as ES7 is developed further and comes closer to release.

If you thought ES6 was good, ES7 is really exciting! Check it out!
