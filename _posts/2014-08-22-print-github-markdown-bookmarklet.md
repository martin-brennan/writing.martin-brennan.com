---
id: 486
title: Print GitHub Markdown Bookmarklet
date: 2014-08-22T11:50:04+10:00
author: Martin Brennan
layout: post
guid: http://www.martin-brennan.com/?p=486
permalink: /print-github-markdown-bookmarklet/
dsq_thread_id:
  - 2948494688
mashsb_shares:
  - 0
mashsb_timestamp:
  - 1464919968
mashsb_jsonshares:
  - '{"total":0}'
categories:
  - Development
  - Share
---

{% include deprecated.html message="There is no guarantee this works anymore, GitHub have probably changed their CSS classes etc. by now." cssclass="deprecated" %}

I was looking for a way to print GitHub markdown documents without all of the GitHub navigation, UI and other extraneous information showing up on the page. Mainly because I like GitHub&#8217;s clean markdown styles, and it&#8217;s very useful to be able to print documentation for certain projects.

All you need to do is add the following bookmarklet to your browser:

```javascript
javascript:(function(e,a,g,h,f,c,b,d)%7Bif(!(f=e.jQuery)%7C%7Cg>f.fn.jquery%7C%7Ch(f))%7Bc=a.createElement("script");c.type="text/javascript";c.src="http://ajax.googleapis.com/ajax/libs/jquery/"+g+"/jquery.min.js";c.onload=c.onreadystatechange=function()%7Bif(!b&&(!(d=this.readyState)%7C%7Cd=="loaded"%7C%7Cd=="complete"))%7Bh((f=e.jQuery).noConflict(1),b=1);f(c).remove()%7D%7D;a.documentElement.childNodes%5B0%5D.appendChild(c)%7D%7D)(window,document,"1.3.2",function($,L)%7B$('%23header, .pagehead, .breadcrumb, .commit, .meta, %23footer, %23footer-push, .wiki-actions, %23last-edit, .actions, .header, .file-navigation, .sunken-menu-contents, .site-footer').remove(); $('%23files, .file').css(%7B"background":"none", "border":"none"%7D); $('link').removeAttr('media');%7D);
```

Here is a demonstration of what it does with the [intridea/grape](https://github.com/intridea/grape/blob/master/README.md) repo&#8217;s README.md file (before and after):

![github print before](/images/github_print_before.png)
![github print before](/images/github_print_after.png)
