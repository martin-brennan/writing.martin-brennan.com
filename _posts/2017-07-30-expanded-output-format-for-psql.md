---
title: Expanded Output Format for PSQL
date: 2017-07-30T20:15:00+10:00
author: Martin Brennan
layout: post
permalink: /expanded-output-format-psql/
---

If you are using [psql](http://postgresguide.com/utilities/psql.html) you may be getting annoyed that your query results look like this for tables with more than one or two columns:

![default display psql](/images/default-psql.png)

Well, there is an answer to this problem. Just enter the command `\x on` and you will turn on the expanded display option, which makes your query results look like this:

![expanded display psql](/images/expanded-psql.png)

Much better!