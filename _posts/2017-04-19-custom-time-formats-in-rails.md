---
title: Custom Time Formats in Rails
date: 2017-04-19T07:30:00+10:00
author: Martin Brennan
layout: post
permalink: /custom-time-formats-in-rails/
---

If you need to set up custom date formats in Rails, for example to show in Views, you can do so by creating a `config/initializers/time_formats.rb` file and adding as many of the following as you want:

```ruby
Time::DATE_FORMATS[:au_datetime] = '%e/%m/%Y %I:%M%P'
Time::DATE_FORMATS[:au_date] = '%e/%m/%Y'
```

You can even use lambdas when defining a format, which will be executed using `.call` when you call `to_s` on your `Time`:

```ruby
Time::DATE_FORMATS[:short_ordinal]  = ->(time) { time.strftime("%B #{time.day.ordinalize}") }
```

This is covered in more detail in the Rails `Time` documentation here:

[http://api.rubyonrails.org/classes/Time.html#method-i-to_formatted_s](Time#to_formatted_s)