---
id: 53
title: SASS vs. LESS, The CSS Preprocessor Debate
date: 2012-07-30T18:58:45+10:00
author: Martin Brennan
layout: post
guid: http://www.martin-brennan.com/?p=53
permalink: /sass-vs-less-the-css-preprocessor-debate/
dsq_thread_id:
  - 966085234
iconcategory:
  - development
mashsb_shares:
  - 0
mashsb_timestamp:
  - 1464987362
mashsb_jsonshares:
  - '{"total":0}'
outofdate:
  - 'true'
outofdatenote:
  - I recommend just using SASS, with the SCSS syntax, which has plugins for just about every build system imaginable these days.
categories:
  - Design
  - Development
  - Tutorial
tags:
  - Compass
  - CSS
  - CSS Preprocessor
  - Javascript
  - LESS
  - Ruby
  - SASS
  - Terminal
---

{% include deprecated.html message="I've never once used LESS in a production frontend. Use SASS (but use the SCSS syntax, not the SASS syntax like this article)! Also there is probably no need to use something like Compass when you can use gulp-css or similar." cssclass="deprecated" %}

A (relatively) recent debate has arisen in the web design community over which CSS preprocessor to use. In this article, I’ll explain the difference between the two major players, SASS and LESS, and explain which is my preferred preprocessor and why.<!--more-->

## CSS Preprocessors

First of all, I’m going to explain what the hell I’m talking about when I’m going on about SASS and LESS and CSS preprocessors. A CSS preprocessor converts the syntax of extended CSS languages, such as SASS and LESS, into regular, browser-readable CSS.

The main advantage of CSS preprocessors, and the thing that makes them most powerful, is that they can do a whole host of things that CSS alone cannot do. Variables, functions, mixins, advanced nesting and conditionals are just a few examples of the advantages of CSS preprocessors. If this has already got you salivating, then read on and I’ll introduce the two main contenders and what they each bring to the field.

## LESS

The first language we’re going to look at is [LESS](http://lesscss.org/). When CSS preprocessors first piqued my interest I started out using LESS, mainly because their website is a lot friendlier looking and less intimidating than SASS’s.

LESS is more straightforward to set up and use than SASS; all you have to do is download `less.js` from their website, and link to it in the `<head>` of your page after your stylesheets, which should use `.less` rather than `.css` as their extension. Here is what a basic inclusion of LESS will look like:

```html
<link rel="stylesheet/less" type="text/css" href="styles.less">
<script src="less.js" type="text/javascript"></script>
```

I’d have to say that LESS is a lot more accessible to beginners that SASS, because it doesn’t require the Terminal/Console trickery that SASS does. The only “problem” that I had with it is that Coda, which is the IDE I was using when I tried LESS out, had no syntax highlighting for LESS, leaving me to slog through and try and create my own which still gives me Vietnam-type flashbacks whenever I see regular expressions. But that’s not really LESS’s fault.

I must admit, I didn’t use LESS very much at all, and nowhere near to its full potential. All I ever used it for were a few variables and some simple mixins. After I used LESS a little while I kind of stopped using it and forgot about CSS preprocessors, until I finally decided to try them out again and discovered SASS.

## SASS

[SASS](http://sass-lang.com/), which stands for Syntactically Awesome Stylesheets, is a little bit more difficult to set up for your projects, especially if you haven’t really used the Terminal before. SASS is a language, along with SCSS, that is is used with [Compass](http://compass-style.org/), a CSS authoring framework.

What Compass does is handle all of the processing of your SASS/SCSS files into regular CSS, and also has handy configuration options like CSS compression and Javascript minification built in. Compass can also be used to “watch” certain folders, and automatically process all of your SASS/SCSS files whenever a change is made.

The easiest way to set up Compass and SASS is by heading over to the [Install](http://compass-style.org/install/) page of the Compass website, where they have a tool that gets you to input some details about your project and then spits out some Terminal commands for you to run.

Note that you must have Ruby already installed to set up Compass. Ruby comes preinstalled on OSX, so if you are using a Mac don’t even worry about it. If you&#8217;re on Windows, take a look at [my article](http://www.martin-brennan.com/install-ruby-and-rubygems-on-windows/) on installing Ruby and Rubygems on Windows. First you will need to run these commands, which updates Ruby and then installs compass:

```shell
gem update --system
gem install compass
```

Then, you will need to switch to your project directory and enter the terminal commands that the Compass site gave you, which will look something like this, depending on the options you chose:

```shell
cd [your_project_dir]
compass create [project_name] --syntax sass --javascripts-dir "js" --images-dir "img"
```

This will create a `config.rb` file in your project directory, which you can use to further configure Compass. For a full list of configuration options, [go here](http://compass-style.org/help/tutorials/configuration-reference/). You are now ready to use Compass and SASS. One final thing that you should do is set up Compass to watch your project directory for changes in SASS files, which is set up by running this command:

```shell
cd ..
compass watch [your_project_folder]
```

If successful, the Terminal should output `"Compass is polling for changes. Press Ctrl-C to Stop."`. I had some Permissions-related problems at this step, which were solved when I deleted my project folder, re-created the folder and then copied its contents back in.

Now that you know how to set up SASS and LASS, we’ll go into how the syntax and major features of both languages differ.

## Feature and Syntax Comparison

Like I said earlier, the greatest thing about CSS preprocessors is that they can do a whole lot more than regular old CSS. The first of these things is variables.

### Variables

If you come from any kind of development background, you will know how important, common and useful variables are. In SASS and LESS, they can be used to store any value, such as hexadecimal colours, fonts, margin or padding settings. The only way the two languages differ is the syntax; SASS uses `$` and LESS uses `@`. Here are some examples from this very blog’s stylesheet (in 2012):

**SASS**

```scss
/* Colour Variables */
$background: #f3f3f3
$mainblue: #3f61b7

/* Spacing Variables */
$gutter: 15px
$height: 2em

/* Font Variables */
$proxima: "proxima-nova", Helvetica,    Helvetica Neue, Arial, sans-serif
$pragmatica: "pragmatica-web", Arial, Helvetica, sans-serif
$code-font: Monaco, Consolas, monospace
```

**LESS**

```less
/* Colour Variables */
@background: #f3f3f3;
@mainblue: #3f61b7;

/* Spacing Variables */
@gutter: 15px;
@height: 2em;

/* Font Variables */
@proxima: "proxima-nova", Helvetica,    Helvetica Neue, Arial, sans-serif;
@pragmatica: "pragmatica-web", Arial, Helvetica, sans-serif;
@code-font: Monaco, Consolas, monospace;
```

### Mixins

This is where preprocessors start to get really useful. Have you ever found yourself applying the same style to a lot of different elements, a box-shadow for instance? This is where mixins come in handy.

Mixins allow you to store a set of CSS properties in a variable. All you have to do is call that variable when you need those styles applied to an element, and they will be applied without you having to type the whole damn thing again. You can even pass arguments to mixins! For example, mixins in **SASS** are denoted using the syntax:

```scss
=shadow($spread)
    box-shadow: -10px 20px $spread rgba(0, 0, 0, 0.2)
    -webkit-box-shadow: -10px 20px $spread rgba(0, 0, 0, 0.2)
    -moz-box-shadow: -10px 20px $spread rgba(0, 0, 0, 0.2)
```


And used like this:

```scss
.element
    +shadow(50px)
```


In **LESS**, mixins are denoted the same as a regular CSS class:

```less
.shadow(@spread: 10px[default value]) {
    box-shadow: -10px 20px @spread rgba(0, 0, 0, 0.2);
    -webkit-box-shadow: -10px 20px @spread rgba(0, 0, 0, 0.2);
    -moz-box-shadow: -10px 20px @spread rgba(0, 0, 0, 0.2);
}
```


And used like this:

```less
.element {
    .shadow(50px);
}
```

You will notice that the SASS language does away with `{}` braces and `;` semicolons, favouring indentation instead. I personally find this great and much easier to type, some others hate it, so YMMV.

### Nesting

Now this is probably the feature that I love the most about preprocessors. Nesting allows you to avoid long selector names and spreading out multiple style definitions for similar things over your entire document like this:

```scss
#header ul a.external {
    font-weight: bold;
}
```


or this

```scss
p.repo-info a {
    text-decoration: none;
}
```

Nesting places all of these definitions under one roof, which is usually the root element or class. This makes for much shorter, more succinct stylesheets. For example, this is sourced from the **SASS** file of this site and demonstrates what I mean perfectly:

```scss
li
    +normal-font($midgrey)
    font: 1.1em/2.2em $pragmatica
    &.comment
        padding: 20px
        background-color: white
        border: 1px solid $code-border
        margin: 20px 0
        list-style-type: none
        +shadow-highspread(50px)
        p, h4
            margin: 0
            line-height: 1.2em !important
        li
            font-size: 100%
```


Which would be represented like this in **LESS**:

```less
li {
    .normal-font(@midgrey);
    font: 1.1em/2.2em @pragmatica;
    &.comment {
        padding: 20px;
        background-color: white;
        border: 1px solid @code-border;
        margin: 20px 0;
        list-style-type: none;
        .shadow-highspread(50px);
        p, h4 {
            margin: 0;
            line-height: 1.2em !important;
        }
        li {
            font-size: 100%;
        }
    }
}
```

Isn’t that much easier to read and add to? Note that mixins and variables are all used within the nesting, and that the use of the `&` character is the same as typing, in the above example, `li.comment`.

### Selector Inheritance

One thing that SASS does that LESS, to my knowledge, does not do is selector inheritance. This allows you to apply all of the styles of another class or element to the class or element that inherits it. For example:

```scss
.message
    padding: 5px
    font-size: 1.8em

.message-error
    @extend .message
    background-color: #FFDEDE
    border: 3px solid red
```

This can be really useful if you have a lot of variants of essentially the same thing.

### Javascript Integration

Something that LESS can do that SASS can not is using Javascript within your stylesheets! Yes you read that correctly, here is a quick example to show you how it works:

```less
@height: `document.body.clientHeight`;
```

All you have to do for this to work is to surround the Javascript with `` ` `` backticks, and LESS will automatically process the code for you.

### Math, Functions and Helpers

In both SASS and LESS, you can use math to do calculations for different values in your stylesheet. You can use multiple different units of measurement in these calculations; LESS will use the first unit provided, and SASS will attempt to convert between units to try and give you what it thinks you want.

For example, say you had a gutter that you needed to be double the size on some elements, you would simply do the following:

**LESS**

```less
@gutter: 5px;
@gutter-big: @gutter * 2;
```

**SASS**

```scss
$gutter: 5px
$gutter-big: $gutter * 2
```

You can even use mathematical operators on colours, though I’m yet to figure out why you’d need to do this, unless you are a robot and know what colour you’d get if you added or multiplied two hex colour values.

Both languages also come with functions and helpers that you can use to speed some things up. For example in less you could use:

```less
darken(@color, 10%);
```

To darken a colour, while in SASS you could use pretty much the same thing:

```scss
darken($color, $amount)
```

There are a huge amount of functions for both languages that you can explore, but I find that SASS is the winner in this category, because Compass can be used to import even more functions and pre-made mixins to help you out by using commands such as:

```scss
@import "compass/css3/border-radius"
```

Which can be called in SASS by using:

```scss
@include border-radius(5px)
```

Which will output the border radius specified with all of the required vendor prefixes. For a full list of Compass imports, go [here](http://compass-style.org/reference/compass/css3/). To view LESS’s functions, go [here](http://lesscss.org/#-color-functions) and to see SASS’s, go [here](http://sass-lang.com/docs/yardoc/Sass/Script/Functions.html).

## The Decision

Ultimately, the two CSS preprocessors are fairly similar in their capabilities and their syntax. I personally now prefer to use SASS, as I love the syntax, especially the dropping of `{}` and `;`, and the way that Compass integrates with it. It also provides a lot more depth for those who require it. For example, it even contains [conditionals and loops](http://sass-lang.com/docs/yardoc/file.SASS_REFERENCE.html#control_directives "Conditionals and Loops").

LESS is easier to approach if you are a beginner and want to start using a preprocessor straight away, but I feel that overall SASS provides a richer and deeper set of features and capabilities.

I know that it’s hard for me to go back to regular CSS now after being spoiled by preprocessors. So which one do you use? Let me know in the comments, and defend your preprocessor of choice’s honour!
