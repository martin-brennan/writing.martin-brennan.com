---
id: 641
title: 'this is not allowed before super'
date: 2015-07-01T21:14:26+10:00
author: Martin Brennan
layout: post
guid: http://www.martin-brennan.com/?p=641
permalink: /this-is-not-allowed-before-super/
mashsb_timestamp:
  - 1464982415
mashsb_shares:
  - 0
mashsb_jsonshares:
  - '{"total":0}'
dsq_thread_id:
  - 3894802270
categories:
  - Development
tags:
  - angular
  - babel
  - error
  - es6
  - Javascript
  - js
  - super
  - this
  - traceur
---
I recently decided to try [Babel](https://babeljs.io/) out as a build system for work in place of [Traceur](https://github.com/google/traceur-compiler). Along the way I found a spec-compliance issue in much of our ES6 Angular codebase. We have several main classes that other classes inherit common functionality from, for example a Model, Collection and Table class. These classes use dependency injection, naturally, because they are being used to write an Angular application. However, what we were doing was causing the exception `‘this’ is not allowed before super()` to be thrown. <!--more-->

To initialize the parent class and inject dependencies we were using the `$injector.invoke()` call on the child class like so:

```javascript
// parent
class Collection {
  constructor($thingToBeInjected, Model) {
    this.Model = Model;
  }
}

// child
import Collection from './Collection';

class PeopleFactory {
  constructor() {
    class People extends Collection {
      constructor($injector, Person) {
        $injector.invoke(super.constructor, this, {
          Model: Person
        });
      }
    }

    People.$inject = ['$injector', 'Person']

    return People;
  }
}

export default PeopleFactory;
```


This was not a problem for us on Traceur `v0.0.79` but as soon as I tried to run code like this through Babel it crashed and burned. The error I was getting was either:

> 'this' is not allowed before super()

or

> 'super property' is not allowed before super()

Both mean similar things. Basically, the older version of Traceur that we were using was not as spec-compliant as it should have been whereas the brand new Babel version I was using was. I checked it out on the latest version of Traceur and the exact same error came up.

In the spec, if you are extending a class you must call the `super()` method before accessing either `this` or a property of `super` e.g. `super.constructor`. The reasoning behind this is that technically JavaScript doesn&#8217;t know what `this` is until you call the superclass. Yehuda Katz gives a really great explanation of it on another [similar babel.js issue](https://phabricator.babeljs.io/T1131).

I found all of this out by filing an error in the `Babel` repo at ['this' is not allowed before super() for AngularJS $injector.invoke() calls #1582](https://phabricator.babeljs.io/T1582). I got a quick reply from [sebmck](https://github.com/sebmck) telling me that I was using a very old Traceur if this actually worked, and that this is the expected behaviour of the spec, which led me in the right direction.

Turns out **sebmck** had actually caused this issue to be fixed in the Traceur compiler too, as seen in the issue <https://github.com/google/traceur-compiler/issues/1797>.

## So&#8230;how can we fix this?

As I mentioned this was all over our entire application so I had to spend an arduous couple of days fixing it. The solution was simple, but the find and replace was the most time consuming. Thankfully I had Johnny Cash&#8217;s _At Folsom Prison_ album to keep my company while I worked. Here is what I needed to do &#8211; instead of `import`ing the superclasses I made them into Angular factories and injected them into the child class that way. Here is what the class definitions looked after extensive rework.

```javascript
// parent
class CollectionFactory {
  constructor($thingToBeInjected) {
    class Collection {
      constructor(Model) {
        this.Model = Model;
      }
    }

    return Collection;
  }
}

CollectionFactory.$inject = ['$thingToBeInjected'];

// child
class PeopleFactory {
  constructor(Collection) {
    class People extends Collection {
      constructor(Person) {
        super(Person);
      }
    }

    People.$inject = ['Person'];

    return People;
  }
}

export default PeopleFactory;
```

Notice that I moved `$thingToBeInjected` into the factory definition constructor, and I&#8217;m just returning the Collection class from the factory without initializing it. This leaves the subclass free to inject and extend it without `import`ing it.

After replacing all of the `$injector.invoke()` calls and creating factories for our common classes the build went off without any hitches in the newest versions of Traceur and Babel!
