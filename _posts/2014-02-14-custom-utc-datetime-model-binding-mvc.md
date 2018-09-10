---
id: 420
title: Custom UTC DateTime Model Binding for MVC
date: 2014-02-14T07:03:24+10:00
author: Martin Brennan
layout: post
guid: http://www.martin-brennan.com/?p=420
permalink: /custom-utc-datetime-model-binding-mvc/
iconcategory:
  - development
dsq_thread_id:
  - 2262733532
mashsb_shares:
  - 0
mashsb_timestamp:
  - 1464982418
mashsb_jsonshares:
  - '{"total":0}'
categories:
  - Development
  - Tutorial
tags:
  - api
  - datetime
  - http
  - model binding
  - MVC
  - POST
  - UTC
---
When working with sending UTC DateTimes via HTTP POST to a .NET Web API or MVC route, the dates are converted by the model binder into the server&#8217;s local time format before being inserted into the database or being used for whatever you want. This is because .NET MVC handles DateTime Model Binding for HTTP POST and GET differently.

> The initially surprising piece of information that it transpires that it actually matters whether you have set the HTTP method to be a GET or a POST.

There are perfectly valid reasons for this that are described in [MVC ModelBinder and Localization](http://weblogs.asp.net/melvynharbour/archive/2008/11/21/mvc-modelbinder-and-localization.aspx) the article that this quote is from</a>, but sometimes you want to keep the DateTimes as UTC to be inserted into the database over HTTP POST. Thankfully, this is fairly easy to do by implementing custom UTC DateTime model binding.<!--more-->

I got the basic implementation from the article [Custom Date Formats and the MVC Model Binder](https://blog.greatrexpectations.com/2013/01/10/custom-date-formats-and-the-mvc-model-binder/). His article works for model binding DateTimes using a custom format, but my implementation just parses UTC DateTimes. This works for DateTimes that were POSTed that were created using `DateTime.Now.ToUniversalTime();`. First of all, you need to create a class that inherits `DefaultModelBinder`.

```csharp
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MyMVCApp
{
    public class UTCDateTimeModelBinder : DefaultModelBinder
    {
        public override object BindModel(ControllerContext controllerContext, ModelBindingContext bindingContext)
        {
            var value = bindingContext.ValueProvider.GetValue(bindingContext.ModelName);

            // Check if the DateTime property being parsed is not null or "" (for JSONO
            if (value.AttemptedValue != null && value.AttemptedValue != "")
            {
                // Parse the datetime then convert it back to universal time.
                var dt = DateTime.Parse(value.AttemptedValue);
                return dt.ToUniversalTime();
            }
            else
            {
                return null;
            }
        }
    }
}
```


Then all you need to do is register the custom UTC DateTime model binding in the `Application_Start` section of the Global.asax file.

```csharp
var binder = new MyMVCApp.UTCDateTimeModelBinder();
ModelBinders.Binders.Add(typeof(DateTime), binder);
ModelBinders.Binders.Add(typeof(DateTime?), binder);
```

And that&#8217;s it! Any DateTimes will now be successfully parsed to UTC when POSTed.
