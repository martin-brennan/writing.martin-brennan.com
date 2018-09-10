---
title: ng-options Undefined On Select
date: 2016-06-18T08:15:00+10:00
author: Martin Brennan
layout: post
permalink: /ng-options-undefined-on-select/
---

I came across this subtle gotcha related to an [ng-options](https://docs.angularjs.org/api/ng/directive/ngOptions) option being undefined on select the other day at work. The initial problem was that out of a list of over a hundred or so options, one of them would cause the required form field validation to kick in because it was undefined on select. I eventually tracked it down to an issue deep within Angular's options code, and the problem was actually nothing to do with Angular itself. <!--more-->

## ng-options Internals

The first thing I had to do was track down where exactly ng-options got the selected value. Basically, what ng-options does internally is make a big hash map of the options' values as keys, along with the type of the option. So for example if this is our setup in our controller:

```javascript
this.countries = [{
  id: 1,
  text: 'Australia'  
}, {
  id: 2,
  text: 'USA'
}, {
  id: 3,
  text: 'United Kingdom'
}, {
  id: 4,
  text: 'Canada'
}, {
  id: 5,
  text: 'India'
}]
```

With a `controllerAs` of `vm`. And this is our template:

```html
<select ng-model="vm.selectedCountry" ng-options="country.text as country.text for country in vm.countries"></select>
```

We end up with this as a hash map in `ng-options`:

```javascript
{
  'string:Australia': value,
  'string:USA': value,
  'string:United Kingdom': value,
  'string:Canada': value,
  'string:India': value
}
```

As you can see here I'm using the `text` key as both the value and the display text for `ng-options`. And this works great, it uses the `.val()` of the select element to get the hash map key and then the correct value for the `ng-option`. You can see this working correctly in the plunkr below:

> [https://plnkr.co/edit/xp0BHqpIQcuHzDyoGUOv?p=preview](https://plnkr.co/edit/xp0BHqpIQcuHzDyoGUOv?p=preview)

## The problem

However, if we introduce jQuery and untrimmed string into the equation we get a big problem. In the absence of jQuery Angular uses [JQLite](https://docs.angularjs.org/api/ng/function/angular.element#angular-s-jqlite) for jQuery-like functionality such as getting the `.val()` of an element. There is one main difference; jQuery trims the value it gets with `.val()` and JQLite does not. So in the following situation in our controller (Canada has a space at the end):

```javascript
this.countries = [{
  id: 1,
  text: 'Australia'  
}, {
  id: 2,
  text: 'USA'
}, {
  id: 3,
  text: 'United Kingdom'
}, {
  id: 4,
  text: 'Canada '
}, {
  id: 5,
  text: 'India'
}]
```

We end up with this as a hash map in ng-options:

```object
{
  'string:Canada ': value
}
```

And this as a select option:

```html
<option value="string:Canada ">Canada</option>
```

So when we select Canada from our options Angular goes and looks it up in the hashmap with a **trimmed** value, provided by jQuery instead of JQLite, while originally it was made with an untrimmed value. So we end up with `undefined` instead. What we are looking for:

```javascript
var selectedOption = options.selectValueMap['string:Canada'];
```

What we should be looking for:

```javascript
var selectedOption = options.selectValueMap['string:Canada '];
```

A working example of this can be found in the plunkr below, if you select different options the values will be logged. See what happens when you choose Canada!

> [https://plnkr.co/edit/5pKuSXp7ize08A1UXpfs?p=preview](https://plnkr.co/edit/5pKuSXp7ize08A1UXpfs?p=preview)

The actual code angular uses in ngOptions can be found here:

> [angular/angular.js ngOptions.js](https://github.com/angular/angular.js/blob/6bc81ae6ef96436b27a9aa6ee3769e394118ecc9/src/ng/directive/ngOptions.js#L499)


## The Solution

The solution is to either a) not use jQuery with Angular or b) trim all of your `ng-options` values! Remember, this is only a problem when using the same string as the value and the text of your `ng-options`, and when Angular is combined with jQuery.
