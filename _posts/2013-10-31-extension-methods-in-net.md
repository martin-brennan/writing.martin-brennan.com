---
id: 379
title: Extension Methods in .NET
date: 2013-10-31T07:37:21+10:00
author: Martin Brennan
layout: post
guid: http://www.martin-brennan.com/?p=379
permalink: /extension-methods-in-net/
iconcategory:
  - development
dsq_thread_id:
  - 1939019343
mashsb_shares:
  - 0
mashsb_timestamp:
  - 1464978864
mashsb_jsonshares:
  - '{"total":0}'
categories:
  - Development
---
Extending the functionality of existing types and classes in .NET is very straightforward with extension methods in .NET. These methods allow you to modify the functionality of a type without modifying the existing type, and are called as if they were a method on the original type. This functionality allows you to add a wide range of comparisons or operations to a method instead of creating functions or externalising methods inside a model or class library.

<!--more-->

Extension methods in .NET are defined in different ways, depending on the language. I have provided an example to demonstrate how extension methods can be used:

  1. Checking to see if a String equals any other String in a parameter array

## Example 1

This extension method is a replacement for the following code, which checks if a string equals any of the other strings provided:

**VB.NET**


```visualbasic
Dim Status As String = "New"
If Status ="New" Or Status = "Pending" Or Status = "In Transit" Then
    Return True
End If
```


**C#**

```csharp
String status = "New";
if (status == "New" || status == "Pending" || status = "In Transit") {
    return true;
};
```

Below is the method, which is called on a string and checks if any of the strings in the provided array are equal to the parent string. Extension methods are defined differently depending on the language. C# requires a static class to be defined with a static method, whereas VB.NET requires all extension methods to be in a public Module, with the `<Extension()> _` attribute appearing before the method definition.

**C#**

```csharp
//Extension methods must be defined in a static class
public static class StringExtension
{
    // This is the extension method.
    // The first parameter takes the "this" modifier
    // and specifies the type for which the method is defined, then
    // the second is an array of string parameters.
   public static bool EqualsAny(this String str, params string[] list) {
        foreach (string s in list)
        {
            if (s == str) {
                return true;
            }
        }
        return false;
    }
}
```

**VB.NET**

```visualbasic
<Extension()> _
Public Shared Sub EqualsAny(Str As String, ParamArray List As String()) As Boolean
    For Each S As String In List
        If S = Str Then
            Return True
        End If
    Next
    Return False
End If
```

And testing the method out (you can also use the method against a variable of a string type):

```csharp
Console.WriteLine("".EqualsAny("a", "b")); //False
Console.WriteLine("a".EqualsAny("a", "b")); //True
Console.WriteLine("b".EqualsAny("a", "b")); //True
```  

As you can see, extension methods can be quite useful tools to complete repetitive actions on an object in .NET. If embedded into a class library, you can namespace them as well. The functionality you can achieve with this is virtually limitless, but you may want to move longer methods into separate functions. Also keep in mind that certain objects are immutable, meaning that you cannot change the value or properties of the object that the extension method is attached to.

Give extension methods a go, and see what you can come up with!
