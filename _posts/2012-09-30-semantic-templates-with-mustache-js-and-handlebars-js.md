---
id: 129
title: Semantic templates with Mustache.js and Handlebars.js
date: 2012-09-30T19:03:14+g:00
author: Martin Brennan
layout: post
guid: http://www.martin-brennan.com/?p=129
permalink: /semantic-templates-with-mustache-js-and-handlebars-js/
dsq_thread_id:
  - 966254376
iconcategory:
  - tutorial
wp88_mc_campaign:
  - 1
mashsb_shares:
  - 0
mashsb_timestamp:
  - 1465018693
mashsb_jsonshares:
  - '{"total":0}'
categories:
  - Development
tags:
  - Handlebars.js
  - HTML
  - Javascript
  - jQuery
  - Mustache.js
  - Semantic Templates
  - SOC
---
Have you ever found yourself mixing in HTML markup with your Javascript logic in increasingly elaborate and difficult ways and crying dramatically to the heavens “There must surely be a better way!”? Well I’m here to tell you that there is, and it comes in the form of logic-less, semantic templates using two different facial hair inspired systems; [Mustache.js](https://github.com/janl/mustache.js) and [Handlebars.js](http://handlebarsjs.com/).

<!--more-->

Before I get into the specifics of Mustache and Handlebars, I’ll outline what semantic templating is all about, and why you should use it. Semantic Javascript templates are used as a replacement to constructing long strings of HTML within your Javascript logic, or even dynamically creating elements and filling them as you go, which violates the principle of [Separation of Concerns](http://en.wikipedia.org/wiki/Separation_of_concerns).

For example, consider the following code to fill out a simple contact card using the hypothetical person’s name, age, email and phone number:

```javascript
var name = "John Smith";
var email = "jsmith@internet.com";
var phone = "1300-FAKE-NUM";
var age = 32;
var contactCard = '<div class="contactCard"><p><strong>' + name + '</strong></p> <p>Email: ' + email + '</p> <p>Phone: ' + phone + '</p> <p>Age: ' + age + '</p>  </div>';
```

Yikes! You can see how messy this is getting even with just four properties and very minimal HTML markup, let alone something substantial that you might see in a real web application. The code demonstrated above is sloppy, error prone, extremely difficult to maintain, may not be supported in some browsers and does not provide clean separation of concerns. Enter semantic templates. Here is what the above might look like using the Mustache template system:

```html
<div class="contactCard">
	<p><strong>{{name}}</strong></p>
	<p>{{email}}</p>
	<p>{{phone}}</p>
	<p>{{age}}</p>
</div>
```

Isn’t that much better and easier to read? Anything between mustaches like this: `{%raw%}{{}}{%endraw%}` will take a property of a Javascript object and render it straight into the template like magic! Now that you are intrigued, we can have a look at Mustache.js and Handlebars.js!

## Rendering with Mustache.js and Handlebars.js

The main difference between Mustache.js and Handlebars.js is that Mustache is the actual templating system, while Handlebars just extends that system and adds in some extra features. First of all, let’s revisit that example and see how it would play out using Mustache:

```javascript
//First we define our data in a "view", which is just an ordinary Javascript object.
var view = {
	name: "John Smith",
	email: "jsmith@internet.com",
	phone: "1300-FAKE-NUM",
	age: 32
};

/*Then, we use the template we created earlier, which I have conveniently placed in the variable "temp", to render the data into a variable using Mustache. I'll go over how templates can be loaded shortly. */
var filled = Mustache.render( temp, view );
```

Which yields the following without much effort at all:

```html
<div class="contactCard">
	<p><strong>John Smith</strong></p>
	<p>jsmith@internet.com</p>
	<p>1300-FAKE-NUM</p>
	<p>32</p>
</div>
```

Rendering is handled slightly differently in Handlebars. You need to compile your template first into a variable, which sort of turns it into a function. Compilation is achieved like this:

```javascript
//Compile the source template.
var compiled = Handlebars.compile(temp);

//Use the compiled template to render the data.
var filled = compiled( view );
```

See? Much easier than HTML mixed up with Javascript. Now that we know how to render the templates, I can show you some ways to store and retrieve your templates.

## Storing, Retrieving and Using Templates

One way to create and use templates is by creating an inline template when you are just about to render your view:

```javascript
var view = {
	name: "John Smith",
	email: "jsmith@internet.com"
};
var filled = Mustache.render( "Email me, {{name}}, at {{email}}!", view);
```

Though this kind of defeats the whole purpose of having templates doesn’t it? Because even though we’re using a template system, we are still defining the template using a big inline string! The next way is to store each template in its own little HTML file and retrieve that file using AJAX when the template is required, using something like [jQuery’s `get` method](http://api.jquery.com/jQuery.get/):

```javascript
//Define our view once again.
var view = {
	name: "John Smith",
	email: "jsmith@internet.com"
};
var filled = "";

//Use jQuery's get method to retrieve the contents of our template file, then render the template.
$.get( 'template_dir/template.html' , function (temp) {
	filled = Mustache.render( temp, view );
});
```

This method may not be ideal when templates are heavily required in your application, and may create a messy nest of callbacks if you need to retrieve the templates asynchronously. The final, and what I think is the best way, is to store all of your templates in a single external file under script tags, and load them all at once so they can be used when required.

{% include in-post-ad.html %}

For example, let’s say we have our contact card scenario again, and a new template is required to load the user’s [Gravatar](https://en.gravatar.com/) image as well as the details we already have. For this, we will define both templates inside a file, within script tags like so. Note that for the Gravatar section I have used three curly brackets {% raw %}`{{{}}}`{% endraw %} instead of two. This is so I can insert HTML into the template without it being [escaped](http://en.wikipedia.org/wiki/HTML#Character_and_entity_references), which is what Mustache and Handlebars do by default:

```html
{%raw%}<script id="template_1" type="text/html">
<div class="contactCard">
	{{{gravatar}}}
	<p><strong>{{name}}</strong></p>
	<p>{{email}}</p>
	<p>{{phone}}</p>
	<p>{{age}}</p>
</div>
</script>
<script id="template_2" type="text/html">
	<img src="http://www.gravatar.com/avatar/{{ hash }}"></img>
</script>{%endraw%}
```

If you are using Handlebars, feel free to use `type="text/x-handlebars-template"` rather than `type="text.html"`. From here, instead of using AJAX to retrieve the templates one by one when they are required, we will retrieve all of the templates at once so they can easily be used later. Note that it may not be ideal for you to retrieve all of them at once in your application if you have a lot of templates, but it should be easy enough to modify the code below to accept an array or something similar to define which templates to load on `document.ready`. The code below is not ideal however, and could be improved upon by using [Namespaces](http://addyosmani.com/resources/essentialjsdesignpatterns/book/#detailnamespacing), but this will do for now.

```javascript
/*This method is called initially to load in all required templates so they do not need to be loaded individually.
@callbackFunction - A callback that is fired after filling in the templates.*/
var Files = {};
function LoadTemplates (callbackFunction) {
	//Get the template file that contains all of the templates.
	$.get('template/temp.html', function (data) {
		/*Loop through all of the script tags in the returned data, and add a new key and value to the files object using the ID of the script as the key and the template markup within as the value.*/
		$(data).filter('script').each(function (e) {
			Files[$(this).attr('id')] = $(this).html();
		})
		callbackFunction();
	});
}

/*Use this method to get the specified template content.
@tmpl - The ID of the template that you require.*/
function GetTemplate(tmpl) {
	//Get the Files key value that corresponds to the requested template.
	return Files[tmpl];
};

//Load all of the templates when the document is ready.
$(document).ready(function () {
	LoadTemplates(function () {
		//Perform any other required code in the callback. In this case, we will want to fill our new templates using another function.
		FillTemplates();
	});
});

//Fill in the templates that we have loaded, and insert them into the page.
function FillTemplates() {
	//Get the required templates from the ones we loaded.
	var card_template = GetTemplate('template_1');
	var grav_template = GetTemplate('template_2');

	//Don't worry too much about this value, Gravatar requires an [MD5](http://en.wikipedia.org/wiki/MD5) hash of the user's email to retrieve their avatar, read more [here](https://en.gravatar.com/site/implement/images/)
	var email_hash = 'e61d50823d8a61ae2e50aa1b62c29ab5';

	//Render the gravatar template using Mustache. We are also using an inline view here just to be quicker, and because there is only one property.
	var rendered_grav = Mustache.render(grav_template, { hash: email_hash });

	//Define the rest of our data in a view object.
	var view = {
		name: "John Smith",
		email: "jsmith@internet.com",
		phone: "1300-FAKE-NUM",
		age: 32,
		gravatar: rendered_grav
	};

	//Then, we can render the final contact card and insert it into our page.
	var rendered_card = Mustache.render(card_template, view);
	$('body').append(rendered_card);
};
```

Now that we have a working example, I’ll tell you about some of the extra goodies that Handlebars and Mustache have in store for you.

## Extra Features

The basics of Mustache are very helpful on their own, though it can handle much more advanced rendering techniques, such as looping through arrays and executing functions. Handlebars further extends this functionality by providing conditional statements and `if...else` logic, as well as helpers. The first of these techniques we will examine are Lists.

### Lists

If you have several copies of the same object in an array, you’ve got yourself a list! For example, say we have some sort of rolodex for our contact manager that contains details for all of our contacts. It might look something like this:

```javascript
var rolodex = {
 contacts: [{
   name: "John Smith",
   email: "jsmith@internet.com",
   phone: "1300-FAKE-NUM",
   age: 32,
   gravatar: rendered_grav_1
 }, {
   name: "Adam West",
   email: "awest@batcave.com",
   phone: "1300-CAP-CRU",
   age: 38,
   gravatar: rendered_grav_2
 }]
};
```

Using this data, you might want to list all of your contacts out using the same template as we did earlier. You would simply wrap the first template with the name of the object property which contains the list in array form, which in our case is `contacts`, using the following notation:

```html
{%raw%}{{#contacts}}
	<div class="contactCard">
		{{{gravatar}}}
		<p><strong>{{name}}</strong></p>
		<p>{{email}}</p>
		<p>{{phone}}</p>
		<p>{{age}}</p>
	</div>
{{/contacts}}{%endraw%}
```

Isn’t that simple? And if your object value happens to be [“falsey”](http://james.padolsey.com/javascript/truthy-falsey/), meaning that it has a value of `null`, `false`, or `undefined`, the template will not be rendered at all! Another way you can use lists is to iterate through a simple string or integer array rather than an array of objects. Consider this example if you wanted to create a list of say, cocktails:

```javascript
var view = {
    cocktails: ["Manhattan", "Rob Roy", "Mojito", "Old Fashioned", "Moscow Mule"];
};
```

You would iterate through them in your Mustache template like so, using the {% raw %}`{{.}}`{% endraw %} notation:

```html
{%raw%}<ul>
	{{#cocktails}}
		<li>{{.}}</li>
	{{/cocktails}}
</ul>{%endraw%}
```

Using lists really comes in handy when rendering out repeating data, like contacts, a list of tweets in a Twitter feed, stocks or anything else you like! Next up, we’ll look at functions.

### Functions

Functions are a great way to pull off even more dynamics with your templates. If Mustache detects that one of the variables passed in is a function, it will run it and render the return value of the function, and the function itself can refer to other variables in the template! Let me show you. Say we wanted a small list of contact names and their email address, with the name bolded, rather than a big contact card. We could do this within the template:

```html
{%raw%}{{#contacts}}
	<li><strong>{{name}}</strong> - {{email}}</li>
{{/contacts}}{%endraw%}
```

Or we could make use of a function! Let’s add one to our rolodex object:

```javascript
var rolodex = {
	contacts: [{
		name: "John Smith",
		email: "jsmith@internet.com",
		phone: "1300-FAKE-NUM",
		age: 32,
		gravatar: rendered_grav_1
	}, {
		name: "Adam West",
		email: "awest@batcave.com",
		phone: "1300-CAP-CRU",
		age: 38,
		gravatar: rendered_grav_2
	}],
	smallcontact: function () {
		return '<strong>' + this.name + '</strong> - ' + this.email;
	}
};
```

And then we can make a slight change to our template (remembering to use three curly braces to ensure the HTML is not escaped).

And we’re done!

### Conditions

Finally, we’re going to examine conditions within semantic templates. We’ll have to use Handlebars to have access to conditions within our templates, as they are unsupported by Mustache. Handlebars has several “block helpers”, which are used to provide extra logical and conditional functionality. There are several block helpers; `with`, `if`, `each` and `unless`, and they all serve a purpose, but I think the most useful one is the `if` helper. You can read about the others [here](http://handlebarsjs.com/block_helpers.html).

The `if` helper can be used to display different content based on a condition. For example, if we wanted to display a “No Email Found” message on our contact card if one is not provided, we might change it to something like this:

```html
{%raw%}{{#contacts}}
	<div class="contactCard">
		{{{gravatar}}}
		<p><strong>{{name}}</strong></p>
		<p>
			{{#if email}}
				{{email}}
			{{else}}
				No Email Found
			{{/if}}
		</p>
		<p>{{phone}}</p>
		<p>{{age}}</p>
	</div>
{{/contacts}}{%endraw%}
```

As you can see, the `if` helper looks just like a regular `if...else` statement, and it can be used to show different data, markup or even run a function depending on the result of the condition. It can be especially handy when displaying different images or alerts depending on the data passed into the template.

### Other Handlebars Features

Of course, block helpers and conditionals are not the only features that Handlebars extends Mustache with. I recommend that you go to the [Handlebars website](http://handlebarsjs.com/) and check out the rest of what it brings to the table, which includes extended Paths, the ability to define custom helpers and of course the rest of the block helpers.

## Wrapping Up

Hopefully this article now has you wishing you had a [badass mustache](http://www.esquire.com/cm/esquire/images/3e/esq-27-shaft-beard-041411-lg.jpg), or failing that it has made you see the light and made you want to use semantic templates in your next Javascript-heavy, client-side application! Because no one likes writing HTML messing up their beautiful Javascript.
