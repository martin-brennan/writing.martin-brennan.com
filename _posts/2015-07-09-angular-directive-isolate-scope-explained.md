---
id: 649
title: Angular Directive Isolate Scope Explained
date: 2015-07-09T22:15:11+10:00
author: Martin Brennan
layout: post
guid: http://www.martin-brennan.com/?p=649
permalink: /angular-directive-isolate-scope-explained/
mashsb_timestamp:
  - 1465007732
mashsb_shares:
  - 0
mashsb_jsonshares:
  - '{"total":0}'
dsq_thread_id:
  - 3918419830
categories:
  - Development
tags:
  - angular
  - component
  - directive
  - isolate scope
  - Javascript
  - scope
---
I’ve written a **lot** of directives this year, and one of the best ways to learn the ins and outs of Angular is to write a lot of isolated directives with lots of different options. One thing I’ve still felt myself occasionally struggling with is the isolate scope on the directive definition object. Not the concept of the isolate scope, but just what in the hell the difference between all the little symbols you can use is. I aim to explain the difference between these symbols because there are some important things to know about them.

<!--more-->

## Isolate Scope?

Isolate scope is what you can use for your directives when you don’t want the directive’s scope to be mixed up with the parent’s scope. If you want to write self-sufficient components in Angular, it is generally agreed that it is A Good Idea™ to use isolate scope for your directives. An isolate scope on a directive definition object might look like this:

```javascript
scope: {
  title: '@',
  record: '=',
  afterSubmit: '&'
}
```


And here, I’ve demonstrated all three different symbol types that can be used for an isolate scope. Let’s make a directive that represents a form with a `title`, a `record` to edit and an `afterSubmit` event to run after the form is submitted. One important thing to remember when declaring isolate scopes, and directives in general, is that **camelCase will be turned into kebab-case**. When you are using the attributes on your directive they must be in kebab case. For example, with our directive, note the `recordEdit` directive name and the `afterSubmit` isolate attribute:

```html
<record-edit title="Person" record="parentCtrl.person" after-submit="parentCtrl.submitted(formData)"></record-edit>
```


### DDO

Before we go any further, let’s define our DDO (Directive Definition Object). We want an element directive with an isolate scope using the `controllerAs` syntax and `bindToController` so we can access the isolate scope properties from `this`. We’ll define the whole thing as an ES6 class (with nothing in the controller yet).

```javascript
class RecordEditController {
  constructor() {}
}

class RecordEdit {
  constructor() {
    return {
      restrict: 'E',
      controller: RecordEditController,
      controllerAs: 'recordEdit',
      bindToController: true,
      templateUrl: 'path/to/recordEdit-template.html',
      scope: {
        title: '@',
        record: '=',
        afterSubmit: '&'
      }
    }
  }
}
export default RecordEdit;
```


## @ (At…Is for Attribute)

The first type of isolate scope “symbol” is the **@** symbol, which is used for a **one-way** databinding of a HTML attribute. There are several things you need to have in mind when using `@`:

  1. The binding is one-way. If you change the value in the directive’s controller it does not affect the parent scope.
  2. The properties defined using `@` are also accessible from the `attrs` parameter of the `link` function for a directive, along with all of the regular HTML attributes e.g.:

```javascript
link: function (scope, element, attrs) {
  console.log(attrs.title); // Person
}
```

As well as this, the binding uses the curly braces syntax or a string literal. You cannot just give it a reference or expression as you will see later with `=`. For example this:

```html
<record-edit title="parentCtrl.editTitle" />
```

Will yield an attr value that will be:

```javascript
this.title // equals "parentCtrl.editTitle"
```

Whereas if we pass it a curly brace expression the same property would pass through its value e.g.

```html
<record-edit title="{{ parentCtrl.editTitle }}" />
```


There isn’t really much to the `@` symbol. You should use it when you just need static information passed through to the directive, like labels or ids or any other value coming down from the parent. You can combine the `@` with a `?` to make it optional, in which case the value will be `undefined`. For example:

```javascript
title: '@?'
```


## = (Equals…Is for Equals)

The second symbol is the **=** symbol, which is used for two way databinding to the isolate scope between the parent and child controller. This is a very useful symbol because it lets the directive manipulate the values passed through the isolate scope and have those changes reflected in the parent controller. This is great for when you need to do things like edit records or transform data in some way.

For example in our `ParentController` the record might look like this:

```javascript
this.record = {
  id: 1,
  firstName: 'John',
  lastName: 'Smith',
  age: 25,
  occupation: null
}
```


It is passed through to our `record-edit` directive like this:

```html
<record-edit record="parentCtrl.record" />
```

Then, in the `record-edit` I can make any changes as required using the form and `ng-model` bindings. We end up with an object that looks like this:

```javascript
this.record = {
  id: 1,
  firstName: 'John',
  lastName: 'Smith',
  age: 24,
  occupation: 'Software Developer'
}
```


And the changes will be reflected in the parent controller’s record! You can also use the `?` symbol in combination with `=` to make the property optional, in which case it will be `undefined`. For example:

```javascript
record: '=?'
```


## & (And…Is for Ampersand)

Finally we have the **&** symbol which is used to bind methods between a parent and child directive. This is the symbol that has the most gotchas in its functionality because Angular does not create a straight one-to-one mapping of the function on the scope property. Instead, it does some voodoo magic and eventually uses `function.apply` with any parameters passed to it, retrieving the parent controller’s reference method along the way.

In our case, we want to run the `submitted` method on the parent controller with the `formData` parameter passed up from the child controller. The parent controller’s method looks like this:

```javascript
submitted(formData) {
  alert(`Thanks for saving ${formData.firstName} ${formData.lastName}'s record!`);
}
```


And the HTML bindings for our `record-edit` directive looks like this:

```html
<record-edit after-submit="parentCtrl.submitted(formData)" />
```


And finally, you would think that the `afterSubmit` method would look like this and you would be good to go right?

```javascript
submit() {
  // do saving stuff

  let formData = {
    firstName: this.record.firstName,
    lastName: this.record.lastName
  }

  // call the bound method with the parameter
  this.afterSubmit(formData);
}
```


**Wrong!** Because Angular is using `function.apply` down the line, the method must be called with an object that has the same keys as the names of the parameters you want to send. Our parameter name is `formData` so the correct way to call the `afterSubmit` method is:

```javascript
submit() {
  // do saving stuff

  let formData = {
    firstName: this.record.firstName,
    lastName: this.record.lastName
  }

  // call the bound method with the parameter
  this.afterSubmit({ formData: formData });

  // (can also be written like this in ES6 because the key name
  // and the variable name match)
  // this.afterSubmit({ formData });
}
```


If you don’t do this, you will just end up very frustrated with parameters that have `undefined` as their value. AND furthermore, if you are passing methods through two levels of directives using `&` e.g. from a parent to a child to a grandchild you will have even more issues. Let’s look at an example of a chain of directives with an `&` isolate scope property and parameters.

    [parentDirective]
      finalise(paramName): '&'
        [childDirective]
          afterSubmit(paramName): '&'
            [grandChildDirective]


If you call the `afterSubmit` method from the `grandChildDirective`, you would expect the `paramName` to be bubbled all the way to the top `parentDirective` right? **WRONG**. Seeing a pattern here? Let’s see it in method calls:

    -> grandChildDirective
      afterSubmit({ paramName: 1 })
        -> childDirective // gets 1 as the parameter as expected BUT
          finalise(1) // because function.apply was used we no longer have the object
            -> parentDirective // gets undefined as the parameter


The way we can get around this is to either redefine the object holding `paramName` in the HTML binding for `childDirective` or to do the same when calling the method in the controller for child directive. So we can either do this:

```html
<parent-directive>
  <!-- how we do it in the template -->
  <child-direcitve finalise="parent.finalise({ paramName: paramName })">
   <grand-child-directive after-submit="child.afterSubmit(paramName)">
   </grand-child-directive>
  </child-directive>
</parent-directive>
```

Or we can do this in the controller of `childDirective`:

```javascript
afterSubmit(paramName) {
  this.finalise({ paramName });
}
```


Which one you use is up to you, and you have to continue this chain as many times as you have levels of hierarchy. Whether you do it in the template or in the controller will make sense in your own situation.

Now, all of this makes it sound like using `&` is a terrible idea, but this is not so. It is extremely useful because the methods called are called **in context**. Meaning that you can refer to `this` in the method and it will refer to the controller where the method is defined. For example if the `childDirective` above had a `record` property I could just access it with `this.record` inside the method.

## Conclusion

Hopefully you understand how the isolate scope symbols work a bit better now. For further reading on the subject you can have a look at the article [AngularJS Sticky Notes Part 2 &#8211; Isolate Scope](http://onehungrymind.com/angularjs-sticky-notes-pt-2-isolated-scope/), the question on StackOverflow and of course the [AngularJS documentation for creating custom directives](https://docs.angularjs.org/guide/directive). You may want to read the [Understanding Scopes](https://github.com/angular/angular.js/wiki/Understanding-Scopes) wiki page on the Angular GitHub repo as well.
