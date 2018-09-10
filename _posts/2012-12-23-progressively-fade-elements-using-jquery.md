---
id: 224
title: Progressively Fade Elements Using jQuery
date: 2012-12-23T22:06:49+10:00
author: Martin Brennan
layout: post
guid: http://www.martin-brennan.com/?p=224
permalink: /progressively-fade-elements-using-jquery/
dsq_thread_id:
  - 990830653
iconcategory:
  - algorithm
mashsb_shares:
  - 0
mashsb_timestamp:
  - 1464920102
mashsb_jsonshares:
  - '{"total":0}'
categories:
  - Algorithm
  - Development
  - Tutorial
tags:
  - Algorithm
  - CSS
  - Javascript
  - jQuery
  - Rails
  - RoR
  - Ruby
  - underscore.js
---
I&#8217;m currently working on a [Rails](http://rubyonrails.org/) app to learn the framework and [Ruby](http://www.ruby-lang.org/en/) as a language a bit better. The app displays a list of elements in order of date created on the main page, and I decided that I would progressively fade the elements using [jQuery](http://jquery.com/) depending on how old they were. I decided to share the algorithm I came up with to help anyone else who is trying to do the same thing.<!--more-->

## Required

For what I did, I used jQuery and [underscore.js](http://underscorejs.org), though you could just use jQuery. My list is an unordered list using the following styles:

```css
ul {
	margin: 0;
}
li {
	padding: 10px;
	background-color: #E3EAFF;
	width: 100%;
	margin: 10px 0;
	list-style-type: none;
	border-radius: 10px;
}
```

The algorithm fades in each item to 100% opacity up until halfway through, where the opacity steps down in increments depending on how many items are left. The tricky part was going down in opacity as the index went up in a function outside the loop. I achieved this by defining a starting point for the opacity which was a tenth of half the size of the array of `li` minus 1, plus 1. This gave me a value of 1.4 for an array that was 10 items, 1.3 for an array of 8 etc. Then all that needed to be done to get the correct opacity was subtract a tenth of the current index from the starting opacity. Here is the code, which may better explain itselft.

```javascript
$(function() {
	var $notelist = $('ul#note-list-main');
	_.each($notelist.find('li'), fadeNote);
});

function fadeNote(el, i, list) {
	var $note        = $(el),
	limit            = list.length,
	opacityStart     = 1 + (((limit / 2) - 1) / 10);
	if (i < (limit / 2)) {
		$note.delay(100 * i).fadeIn('fast');
	} else {
		var opacity = opacityStart - (i * 0.1);
		$note.delay(100 * i).fadeTo('fast', opacity);
	}
}
```

Here is a [JSBin](http://jsbin.com/ofiqid/1/) for a more interactive example. On another note, I'm really enjoying RoR as I start to understand it a bit better while creating this app. I'm loving how easy the syntax is to use and guess, and Rails abstracts so much tedious work away from the developer. I'm also looking forward to using underscore.js, it's really intriguing me at the moment and I'm on the lookout for more ways to use it.
