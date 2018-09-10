---
id: 171
title: The Dirty Truth Behind IIF()
date: 2012-11-21T22:14:49+10:00
author: Martin Brennan
layout: post
guid: http://www.martin-brennan.com/?p=171
permalink: /the-dirty-truth-behind-iif/
dsq_thread_id:
  - 965382822
iconcategory:
  - development
mashsb_shares:
  - 0
mashsb_timestamp:
  - 1464920117
mashsb_jsonshares:
  - '{"total":0}'
categories:
  - Development
  - Share
tags:
  - ASP.NET
  - Javascript
  - Ternary Operator
  - VB.NET
---
I was having trouble using the VB.NET `IIF()` feature today, it was not behaving the way that I expected it would in that it was still evaluating both results no matter whether or not the expression was returning True or False.

<!--more-->

I had expected it to work like Ternary Operators in JavaScript; the first expression would be evaluated and then depending on the True or False result a different value would be returned. For example, in the operation below the value 5 would be returned because the expression would return true.

```javascript
var myVar =  true;
var mySecondVar = myVar ? 5 : 10;
```

This, however, is not the case in VB.NET. After reading [this article](http://secretgeek.net/iif_function.asp "IIF is a function, not a language feature") by Leon Bambrick, the truth began to reveal itself. It the article, Leon explains that in VB.NET `IIF()` is a function rather than a feature of the language. Therefore, each of the parameters for the function are evaluated before the function is executed, making `IIF()` thoroughly useless for evaluating anything but already defined values.

For example, I was trying to use `IIF()` to check if there was a logged in user, and to return different values accordingly:

```visualbasic
Dim Username As String = IIF(Membership.GetUser.Email Is Nothing, "", Membership.GetUser.Email)
```

This of course was producing an `"Object reference not set to an instance of an object"` error, because even though `Membership.GetUser.Email` was nothing, the `IIF()` function needed to execute `Membership.GetUser.Email` before the `IIF()` comparison could be run, because it is the FalsePart parameter of the function.

Basically, if you are ever doing something like this it is better to use the long way instead of using IIF, like so:

```visualbasic
Dim Username As String = String.Empty
If Membership.GetUser.Email Is Nothing Then
    Username = ""
Else
    Username = Membership.GetUser.Email
End If
```

And you shouldn&#8217;t have any more issues!

**NOTE:** C# does not have this issue, as it uses the same Ternary Operator syntax as JavaScript i.e.

```csharp
var a = (c == 0) ? 0 : (b/c);
```
