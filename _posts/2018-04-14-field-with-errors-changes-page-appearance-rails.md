---
title: field_with_errors changes page appearance in Rails
date: 2018-04-14T19:20:00+10:00
author: Martin Brennan
layout: post
permalink: /field-with-errors-changes-page-appearance-rails/
---

I had a minor issue with my Rails view when I had a list of radio buttons wrapped in labels. When there are form errors on a field like a radio button, Rails puts the CSS class `.field_with_errors` on that field. This causes some issues with alignment as seen in the screenshot below:

![field with errors](/images/fieldwitherrors.png)

All you need to do to fix this is make the `.field_with_errors` class display inline like so:

```css
.field_with_errors { display: inline; }
```