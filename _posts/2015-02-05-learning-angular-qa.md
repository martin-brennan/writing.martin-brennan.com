---
id: 590
title: 'Learning Angular Q&#038;A'
date: 2015-02-05T22:41:50+10:00
author: Martin Brennan
layout: post
guid: http://www.martin-brennan.com/?p=590
permalink: /learning-angular-qa/
dsq_thread_id:
  - 3487824717
mashsb_shares:
  - 0
mashsb_timestamp:
  - 1464919864
mashsb_jsonshares:
  - '{"total":0}'
categories:
  - Development
tags:
  - angular
  - es6
  - events
  - frontend
  - Javascript
  - SPA
  - template
---
While I’ve been learning Angular for the past couple of weeks, I’ve been able to get a pretty good idea of how the framework works as well as a lot of the best practices for it. While reflecting on what I had learned, I came up with several questions for myself to research to get a better understanding of more patterns and what I should use for certain things in Angular. Here are the questions I came up with and the results of my research.

<!--more-->

## 1. How do I send events between views, in a similar way to how a global event bus can be created for Backbone.js?

As it turns out, this is quite straightforward with Angular and is achieved using the `$scope` and the `$rootScope` service. Global events can be bound to the `$rootScope` object, but that generally isn’t a good idea unless completely necessary.

There are three different situations where you may need to pass events. They are:

  1. From the ParentController to the ChildController
  2. From the ChildController to the ParentController
  3. When there is no Parent to Child Relationship (global event)

Let’s look at each of these in turn. To pass an event from the ParentController to the ChildController, you can use the following syntax:

```javascript
function ParentController($scope) {
  $scope.$broadcast('eventName', { key: 1 }); // send the event
}

function ChildController($scope) {
  $scope.$on('eventName', doSomethingWithData); // capture the event

  function doSomethingWithData(event, data) {
    console.log(data.key);
  }
}
```

For an event that is passed from the ChildController to the ParentController, use the following syntax:

```javascript
function ParentController($scope) {
  $scope.$on('eventName', doSomethingWithData);

  function doSomethingWithData(event, data) {
    console.log(data.key);
  }
}

function ChildController($scope) {
  $scope.$emit('eventName', { key: 1});
}
```

You can see here the difference between using $emit and $broadcast to send the events between the two. The events are bound to `$scope`, so events are either sent upwards to the `$rootScope` in the case of `$emit`, or downwards to all child scopes using `$broadcast`. Finally, the way to broadcast global events via the `$rootScope` service is as follows:

```javascript
function SomeController($rootScope) {
  $rootScope.$broadcast('eventName', { key: 1});
}

function SomeOtherController($rootScope) {
  $rootScope.$on('globalEvent', doSomethingWithData);

  function doSomethingWithData(event, data) {
    console.log(data.key);
  }
}
```

See the gist at <https://gist.github.com/3afbc66e144d13f19c56.git> for a full example with HTML source.

The AngularJS documentation on  [$rootScope.Scope](https://docs.angularjs.org/api/ng/type/$rootScope.Scope) has more information on `$emit`, `$on` and `$broadcast`.

## 2. What’s the best way to cache data and resources?

There are a couple of different ways that I’ve found so far to cache data and resources in Angular. There are likely many more nuanced ways than these two, and I need to research them more thoroughly to get a better idea of the accepted solutions. To cache data, you can simply set the `cache: true` property on the `$http` service. If you want more information on how the Angular cache works vs. the browser case, read this [comparison of AngularJS cache vs. browser HTTP cache](http://www.metaltoad.com/blog/angularjs-vs-browser-http-cache).

For templates, if they are not specified inline for a route and are instead specified using the `templateUrl: 'path/to/template.html'` syntax, Angular will retrieve the template using AJAX and then store it using the [$templateCache](https://docs.angularjs.org/api/ng/service/$templateCache) service. So any subsequent requests for this template will be retrieved from the cache. You can also manually preload templates into the cache using the following syntax:

```javascript
$templateCache.put('templateId.html', 'This is the content of the template');
```

You can also use the [gulp-angular-templatecache](https://github.com/miickel/gulp-angular-templatecache) plugin for gulp to precompile all of your HMTL templates and preload them into the template cache, so they don’t need to be retrieved via AJAX each time they are first requested. See the docs on the GitHub project page for more information on how to set this up in your build pipeline.

## 3. Should directives be used instead of controllers?

I knew that the usage of global `ng-controllers` will be banned in Angular 2.0, so I wanted to find out what the suggested alternative was. The focus in the next version it turns out is directives, and this can also be applied in the current version of Angular by only using controllers in conjunction with directives.

To this end, controllers should mainly be used as a way to get data to the directive, acting only as a View Model. Directives are reusable everywhere in your application, so they should handle all DOM interaction or manipulation. What this means is that you should bind events to functions on the directive, and you should also do anything like showing/hiding elements, animations etc. on the directive.

The directive should also be handling its own functionality. For example, if you had a NewPerson directive linked to a NewPersonController, the `addPerson()` method should be added to the NewPersonController. This encourages reusable components that do not have repetitive functionality copied and pasted over different controllers.

Furthermore, your directives should also be handling all of their own validations and DOM events. In relation to loading data, this is handled in your controller like usual. The directive can either define a controller inline, in the same file or in a separate file, and it supports the `controllerAs` syntax like the router. Anything from the controller will be bound to the same thing as you defined in `controllerAs` in the template. Any [isolate scope](http://www.martin-brennan.com/angular-directive-isolate-scope-explained/) properties will also be bound to the `controllerAs` property in the template so long as you have set `bindToController` to true. In the link function for the directive the `controller` variable will contain this information if no `ngModel` is required, otherwise it will be available on `scope.controllerAsName.propName`. Your controller should mainly act as a View Model, fetching the data and then presenting it to the directive.

## 4. Do ES6 classes have a place in Angular?

Classes in ES6 are basically syntactic sugar around the normal way that you define constructors in JavaScript. So anything that needs to create an instance using the `new` keyword can use ES6 classes. For example, classes can be used for services, factories and controllers. <del datetime="2015-07-09T12:58:10+10:00">However they shouldn’t really be used for directives</del>. Directives require a return object which contains the [Directive Definition Object](https://docs.angularjs.org/api/ng/service/$compile#directive-definition-object), so they are defined as classes slightly differently. As long as your class&#8217;s `constructor` returns a DDO you can use classes for directives just fine.

## 5. What are some performance issues and considerations to be aware of when working with Angular?

When updating a value on the controller View Model that is currently being passed to an `ng-repeat` directive, use the `track by` syntax which was introduced in Angular 1.2. This is to prevent the recalculation of the entire list and all of the DOM nodes every time another data fetch is made. By default, Angular tracks each different element in the list used by `ng-repeat` by using a unique `$$hashKey` property that Angular generates. You can specify any other unique identifier in place of this, such as the conveniently unique primary key (in the case of a list of objects). This identifier is used to link the DOM node to the list item that it represents.

This is not a huge performance gotcha, but you should be sure of the difference between `ng-hide + ng-show` and `ng-if + ng-switch`. The previous two simply apply `display: none;` to the element and the latter two do not render the element into the DOM tree. You’ll want to keep this in mind so you are not unnecessarily watching invisible DOM nodes for no reason.

If you are using the `{% raw %}{{}}{% endraw %}` (curly brace) syntax for data binding, you may notice that sometimes you see a flash of these curly braces before Angular kicks in. To avoid this you can use the `ng-bind` directive, which provides one-way data binding for properties. The curly brace syntax is also slower than the `ng-bind` directive. This is because `ng-bind` is a directive with a watcher, which only updates when the actual value is updated. The curly braces however are dirty checked on **every digest cycle**. If you must use the curly braces syntax, you can force one-way databinding without further dirty checking with the `::` syntax e.g. `{% raw %}{{::firstName}}{% endraw %}`.

Avoid using `$watch` manually if you don’t necessarily need it. This can be killer for performance, and you can use a combination of services, data binding and reference bindings to achieve the same functionality. The watch expression will be called on every `$digest` cycle and watching complex objects will have adverse memory and performance implications. [See the $watch docs for more information](https://docs.angularjs.org/api/ng/type/$rootScope.Scope#$watch).

## 6. How is internationalization achieved in Angular?

The [angular-translate](http://angular-translate.github.io/) module can be used to provide translations. This module uses .json files for each different language that you want to provide, which is basically like a .resx file, a dictionary of unique keys and values. Each .json file should have the same keys, just different values. Here is a trivial example:

**en.json**

```json
{
    TITLE: 'Home Page',
    GREETING: 'Hello!'
}
```

**es.json**

```json
{
    TITLE: 'Página de inicio'
    GREETING: 'Hola!'
}
```

The actual implementation in templates is similar to a directive. This is how it would look in your templates:

```html
{% raw %}<h1>{{ 'TITLE' | translate }}</h1>
<p>{{ 'GREETING' | translate }}, {{ name }}</p>{% endraw %}
```

`angular-translate` also exposes a service called `$translate` which can be used to tranlsate text within your controller, directive and service JavaScript code. Here is another snippet from their docs:

```javascript
$translate('TITLE').then(function (translation) {
  $scope.translatedText = translation;
});
```


## 7. Conclusion

I hope this Q&A of what I’ve been learning so far with Angular has been enlightening for you as well. Obviously I still have a long way to go to complete understanding of the different patterns and best practices, but I feel that I have been heading in the right direction so far. One tip I can give to people learning Angular is to not rely on the tutorials on angularjs.org! Search for best practices and patterns, and see what is changing in v2.0 for a better idea of the current line of thought for building Angular applications.
