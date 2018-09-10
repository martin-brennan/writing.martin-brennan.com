---
id: 367
title: Auto-Generate Property In VB.NET
date: 2013-09-27T08:30:02+10:00
author: Martin Brennan
layout: post
guid: http://www.martin-brennan.com/?p=367
permalink: /auto-generate-property-in-vb-net/
iconcategory:
  - development
dsq_thread_id:
  - 1800279092
mashsb_shares:
  - 0
mashsb_timestamp:
  - 1465016711
mashsb_jsonshares:
  - '{"total":0}'
categories:
  - Development
  - Productivity
---
At work back when I was using Visual Studio 2010, I had a macro for VB.NET that would generate properties in VB.NET from a list of private methods with a click of a button, because the VB.NET class property syntax is extremely tedious to write even for classes with a small number of properties. With Visual Studio 2012 [macros have been removed](http://stackoverflow.com/questions/12062515/can-i-record-play-macros-in-visual-studio-2012-2013) so I had to find an alternative or otherwise suffer with copy/pasting or writing the whole thing out!

Luckily I came across an answer on StackOverflow that utilizes code snippets to generate a property in VB.NET including the private variable. You can see the answer here: [VB.Net Keyboard Shortcut to auto-generate a Property on StackOverflow](http://stackoverflow.com/questions/3736932/vb-net-keyboard-shortcut-to-auto-generate-a-property). All you need to do is write the word `Property` and hit tab twice, and it will generate something like this:

```visualbasic
Private _PropName As String
Public Property PropName() As String
    Get
        Return _PropName
    End Get
    Set(ByVal value As String)
        _PropName = value
    End Set
End Property
```
