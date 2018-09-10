---
title: PhantomJS Element Not Found Using Capybara
date: 2017-07-08T12:30:00+10:00
author: Martin Brennan
layout: post
permalink: /phantomjs-element-not-found-capybara/
---

I ran into an odd issue this week where one of our Rails feature specs using [Capybara](https://github.com/teamcapybara/capybara) was failing because the [PhantomJS driver (driven by Poltergeist)](https://github.com/teampoltergeist/poltergeist) couldn't find an element on the page. This was strange because the same element was tested on a different page and PhantomJS could find it just fine. This occurred even with `$(document).ready()`. This is kind of the layout of the page:

```html
<script>
  ViewJS.initialise();
</script>

<div id="element-to-find"></div>
```

And the JS we were trying to run:

```javascript
$(document).ready(function () {
  document.getElementById('element-to-find');
});
```

Our specs were failing with a JS error saying that element `element-to-find` could not be found. We messed around a bit with some `page.body` calls to get the HTML of the page during the testing, and everything seemed to be in order. The only different thing about the view was that it had quite a few nested partials and the JS code was at the bottom level of these partials. On a whim, I changed the HTML to look like this, moving the JS call to the bottom of the page:


```html
<div id="element-to-find"></div>

<script>
  ViewJS.initialise();
</script>
```

...and it worked! It is, of course, best practice to load JavaScript at the bottom of each page, so I guess we had gotten lucky so far with how quickly the HTML was loading. Though I'm not sure why `$(document).ready()` didn't help in this situation. If you have any insight please let me know!