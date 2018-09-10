---
id: 533
title: Goodbye RequireJS, Hello Browserify
date: 2014-11-16T19:06:44+10:00
author: Martin Brennan
layout: post
guid: http://www.martin-brennan.com/?p=533
permalink: /goodbye-requirejs-hello-browserify/
wp88_mc_campaign:
  - 1
dsq_thread_id:
  - 3229970464
mashsb_shares:
  - 0
mashsb_timestamp:
  - 1464985426
mashsb_jsonshares:
  - '{"total":0}'
categories:
  - Development
tags:
  - backbone
  - browserify
  - Javascript
  - jQuery
  - module
  - node
  - npm
  - underscore
---

{% include deprecated.html message="I no longer believe that Browserify is the way to go for JS modules, I was just entranced by it at first. I've put my bets on ES6 module syntax with a transpiler such as Babel or Traceur, combined with SystemJS" cssclass="deprecated" %}

For a long time now, I&#8217;ve been relying on [RequireJS](http://requirejs.org/) for JavaScript dependency and module management and we have it incorporated into our front-end JavaScript workflow at work as well. There are a few things that have always bothered me about it:

1. Third party libraries, if not properly set up to use AMD, are a pain to include and use. Sure there are shims in RequireJS, but I&#8217;ve always found the system flaky and hard to understand.

2. Though not always an issue, we&#8217;ve found that sometimes modules simply do not load in the correct order, and it is difficult to diagnose the issue or to force them to load in the required order.

3. Dependency management amongst third party modules is often a nightmare, as the location of the modules that the third party libraries require are often not in the same location as where you want them.

4. The `require` and `define` syntax can sometimes be laborious, e.g. for libraries that do not need a variable in the `function () {}` call.

5. I&#8217;ve found that require modules are hard to concatenate in the correct order into one file, as well as uglifying at the same time.

These things have had me waiting for a new module system to come along and finally it&#8217;s time to say goodbye RequireJS, hello [Browserify](http://browserify.org).<!--more-->

## Browserify

Browserify is a module system that is heavily influenced by and based upon the [node.js](http://nodejs.org) module system, and even provides interoperability with most node modules. This means that along with your own JavaScript modules and third party libraries, you can use many of the node modules found on [NPM](https://www.npmjs.org/).

The **single killer feature** of Browserify is the way it combines and packages all of your modules recursively into one single file. It&#8217;s smart enough to order all of the modules in the order that they will need to load in, and there are also plugins for Browserify for uglifyjs, so you can minify at the same time. In this article, I&#8217;ll set up an extremely simple JavaScript application using Backbone to demonstrate how Browserify modules work and also the inclusion of npm modules in the form of [jQuery](http://jquery.com/), [Underscore](http://underscorejs.org) and [Backbone](http://backbonejs.org). You can find the source on my GitHub at [https://github.com/martin-brennan/browserify-example](https://github.com/martin-brennan/browserify-example).

## Getting Started

To get set up, first install Browserify. Then, install both watchify (a browserify file watch extension) and and uglifyify (uglifyjs for Browserify). Also, we will need to install our dependencies of underscore, jQuery and Backbone.

```
npm install -g browserify
npm install --save-dev uglifyify
npm install -g watchify
npm install underscore
npm install backbone
npm install jquery
```


Once that&#8217;s done we can structure our sample application. All it&#8217;s going to do is get a list of people from a file called people.json and display their name and email address in an unordered list. The html of the page looks like this, and references out.js which is what I&#8217;ve named the output from browserify:

```html
<html>
<head>
	<title>People</title>
	<script type="text/javascript" src="out.js"></script>
</head>
<body>
	<ul id="people">

	</ul>
</body>
</html>
```


## JavaScript

Our entry point for our application is located under `js/src/app.js`. It&#8217;s here that we will `require` all of our code for running the application. All it does is require the modules and then run the backbone collection fetch, then renders the view showing all of the people. An important thing to note is that the `$` variable must be manually assigned to `Backbone.$` because it is not injected into the global namespace.

```javascript
var _ = require('underscore');
var $ = require('jquery');
var Backbone = require('backbone');
Backbone.$ = $;
var PeopleView = require('./src/view/people.js');
var PeopleCollection = require('./src/collection/people.js');

$(document).ready(function () {
	var people = new PeopleCollection();
	people.fetch().then(function () {
		var peopleList = new PeopleView({ collection: people });
		peopleList.render();
	});
});
```


The file under `js/src/model/person.js` is the backbone model representing each person:

```javascript
var _ = require('underscore');
var Backbone = require('backbone');

module.exports = Backbone.Model.extend({
	defaults: {
		id: null,
		name: null,
		email: null
	}
});
```

The file under `js/src/collection/people.js` uses the model to define what a person looks like, then defines the url to fetch the person data from, which is under &#8216;./people.json&#8217;:

```javascript
var _ = require('underscore');
var Backbone = require('backbone');
var personModel = require('../model/person.js')

module.exports = Backbone.Collection.extend({
	model: personModel,

	url: './people.json'
});
```

Finally, under `js/src/view/people.js` is the backbone view that is attached to the `#people` element in the HTML. The view takes all of the models in the backbone collection and renders them into an unordered list, using an underscore template for each person&#8217;s details.

```javascript
var _ = require('underscore');
var $ = require('jquery');
var Backbone = require('backbone');
Backbone.$ = $;

module.exports = Backbone.View.extend({
	el: '#people',

	template: _.template("<li><%= name %> [<a href='mailto:<%= email %>'><%= email %></a>]</li>"),

	render: function () {
		_.each(this.collection.models, function (model) {
			this.$el.append(this.template(model.toJSON()));
		}, this);
		return this;
	}
});
```

You can run this application locally on a python SimpleHTTPServer using the command `python -m SimpleHTTPServer 8000`.

## Magic

You&#8217;ve probably already noticed the node-like module syntax in each of these files. All you need to do to require a node or JavaScript module is use the `var module = require('../module/name.js');` syntax. And for creating modules, you only need to define `module.exports` in the file, and point it at an object that you want to return for the module (e.g. an object, function or Backbone model/view/collection).

Now, the basic functionality of browserify is just to recursively require all of the modules and put them into a JavaScript file, which you can achieve with this command:

```
browserify js/app.js -o out.js
```

This may get a bit tedious to do every time you want to test some changes. Thankfully the watchify module that we installed has us covered! Every time you change and save a file that is required by app.js somewhere down the chain, browserify will recompile all the files into app.js.

```
watchify js/app.js -o out.js
```

Finally, after we&#8217;re sure that everything works correctly, you might want to uglify the output file ready for production. To do this, we will use the uglifyify library that we installed. Using the following command the browserify command will run then the output will be compressed and have the variables renamed.

```
browserify js/app.js | uglifyjs -o out.js
```

## Conclusion

Granted, this example is quite simplistic and there is some more to consider with more javascript-heavy applications. There are a lot of articles and helpful documentation [on the browserify website](http://browserify.org/articles.html) and I suggest you check them out! I&#8217;ve found that a lot of developers are starting to use browserify as an alternative to requirejs, and I love it for the ability to use node modules, as well as its great module definition system and easy dependency management.
