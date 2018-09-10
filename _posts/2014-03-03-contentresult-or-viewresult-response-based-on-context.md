---
id: 416
title: ContentResult or ViewResult Response Based on Context
date: 2014-03-03T07:38:44+10:00
author: Martin Brennan
layout: post
guid: http://www.martin-brennan.com/?p=416
permalink: /contentresult-or-viewresult-response-based-on-context/
iconcategory:
  - development
dsq_thread_id:
  - 2347758256
mashsb_shares:
  - 0
mashsb_timestamp:
  - 1465016709
mashsb_jsonshares:
  - '{"total":0}'
categories:
  - Development
tags:
  - .net
  - api
  - 'C#'
  - controller
  - MVC
---
In .NET MVC there are times where you may want to return either a `ContentResult` or `ViewResult` depending on the situation. For example you may want to return an `application/json` result for an API request but a structured view with timing information (such as when using MiniProfiler) when visiting the route in the browser.

I had to find out how to construct the different types of results separately first. The main properties that need to be set for a new `ViewResult` object are the ViewName and the ViewData. ViewData has a Model property where you can set the model that you would like to return with the view. The `SimpleResponse` model is a simple model that just has a JSON property that I use to display the JSON output of an API route in a nicely-formatted way.<!--more-->

```csharp
var view = new ViewResult();
view.ViewName = "~/Views/Sys/Response.cshtml";
view.ViewData.Model = new Models.SimpleResponse() { JSON = APIResponse.Serialize(obj) }; //This just uses Newtonsoft.Json to serialize the response
return view;
```

For a `ContentResult`, you only need to set the content type and the content of the response. Because the API I am developing uses JSON responses, the content type is `application/json; charset=UTF-8`.

```csharp
var content = new ContentResult();
content.Content = Serialize(obj);
content.ContentType = "application/json; charset=UTF-8";
return content;
```

Now, we can put this all together into a practical example. Inside a class called `APIResponse` I have a method called `Resolve`.

```csharp
/// <summary>
/// Figures out whether the response should be a ContentResult or
/// a ViewResult. If the request is local and the request contenttype
/// is not "application/json; charset=UTF-8", then that means a developer
/// is looking at the page in a browser. This renders the Response.cshtml
/// View with MiniProfiler so query statistics can be observed.
///
/// Otherwise, a ContentResult is returned with the JSON serialized object
/// which is passed in from the controller.
/// </summary>
/// <param name="obj">The object to serialize to JSON from the controller.</param>
public static ActionResult Resolve(object obj)
{
	if (HttpContext.Current.Request.IsLocal && HttpContext.Current.Request.ContentType != "application/json; charset=UTF-8")
	{
		var view = new ViewResult();
		view.ViewName = "~/Views/Sys/Response.cshtml";
		view.ViewData.Model = new Models.SimpleResponse() { JSON = WOLASAPI.lib.APIResponse.Serialize(obj) };
		return view;
	}
	else
	{
		var content = new ContentResult();
		content.Content = Serialize(obj);
		content.ContentType = "application/json; charset=UTF-8";
		return content;
	}
}

// You can then use this in a controller like so
public ActionResult GetPerson(int id) {
    var person = db.person.Find(id);
    return APIResponse.Resolve(person);
}
```
