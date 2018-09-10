---
id: 582
title: Highlighting JavaScript this Keyword in Sublime Text 2
date: 2015-02-01T19:32:04+10:00
author: Martin Brennan
layout: post
guid: http://www.martin-brennan.com/?p=582
permalink: /highlighting-javascript-keyword-sublime-text-2/
dsq_thread_id:
  - 3474766458
mashsb_shares:
  - 0
mashsb_timestamp:
  - 1464919887
mashsb_jsonshares:
  - '{"total":0}'
categories:
  - Development
tags:
  - Javascript
  - Sublime Text 2
  - Theme
  - this
---
I&#8217;ve looked for something like this before but I&#8217;ve only recently found it. Sublime Text 2 uses textmate themes which can use regular expressions and scopes to highlight certain keywords that are only relevant in certain languages. I got a new theme which I love called [itg.flat](https://github.com/itsthatguy/theme-itg-flat "itg.flat") and while the colors are great, it was lacking a highlight for the `this` keyword in JavaScript, which makes in harder to spot and locate scope issues.

I found this on a Sublime Text 2 forum post, which highlights the keyword. You just need to add this to the `.tmtheme` file for your theme, which will usually be located in `{user}/Library/Application Support/Sublime Text 2/Packages/Theme - Name/` for Mac and `%APPDATA%\Sublime Text 2\Packages\Theme - Name\` in Windows:

```xml
<dict>
	<key>name</key>
	<string>Super this (JavaScript)</string>
	<key>scope</key>
	<string>source.js variable.language.js</string>
	<key>settings</key>
	<dict>
		<key>fontStyle</key>
		<string>bold italic</string>
		<key>foreground</key>
		<string>#DE4DB4</string>
	</dict>
</dict>
```

You can get rid of the bold/italic if you want or change the hex color code too. You may also want to check out the [Sublime Text 2 Color Scheme Editor](https://github.com/facelessuser/ColorSchemeEditor). Here you can see the result. Before:

![before](/images/before.png)

After:

![before](/images/after.png)
