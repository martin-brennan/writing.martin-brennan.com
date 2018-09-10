---
id: 290
title: Using Reserved Words as Identifiers in VB.NET by Theo Gray
date: 2013-02-15T18:23:19+10:00
author: Martin Brennan
layout: post
guid: http://www.martin-brennan.com/?p=290
permalink: /using-reserved-words-as-identifiers-in-vb-net/
iconcategory:
  - Development
dsq_thread_id:
  - 1084293286
mashsb_shares:
  - 0
mashsb_timestamp:
  - 1464920076
mashsb_jsonshares:
  - '{"total":0}'
categories:
  - Development
tags:
  - ASP.NET
  - Javascript
  - Languages
  - Programming
  - Reserved Keywords
  - VB.NET
---
I came across a problem at work the other day when the plugin that I was using, [jQuery file uploader](http://blueimp.github.com/jQuery-File-Upload/), required specific properties to be returned to it from the VB.NET object deserialisation when an error occurred. One of these properties was `Error`, which is a [reserved language keyword](http://www.theogray.com/blog/2009/03/using-reserved-words-as-identifiers-in-vbnet) in VB.NET. Ordinarily I would never be using reserved words as identifiers in VB.NET, since you can&#8217;t anyway because the compiler doesn&#8217;t allow it and it&#8217;s usually a very bad idea. But in this case it was either use a reserved keyword or have to modify the plugin source which I wasn&#8217;t too keen on doing.

I came across this article by [Theo Gray](http://www.theogray.com/blog/2009/03/using-reserved-words-as-identifiers-in-vbnet) that outlined that it was as simple as surrounding the property in square brackets `[]`, much in the same way you can use [reserved keywords as column names in MSSQL](http://stackoverflow.com/questions/285775/how-to-deal-with-sql-column-names-that-look-like-sql-keywords). This worked great and it was a perfectly simple solution to my problem, but I certainly won&#8217;t be making a habit of it!
