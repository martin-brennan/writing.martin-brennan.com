---
title: Simulating the Mouse Click Event in JavaScript
date: 2017-04-20T19:30:00+10:00
author: Martin Brennan
layout: post
permalink: /simulating-mouse-click-event-javascript/
---

I was trying to write a [capybara]() feature spec for a date input using [flatpickr](). I wanted to assert that once I selected a date in the picker, it would be successfully entered into the input field in the required format. To do this I wanted to simulate a mouse click event in JavaScript. However, I hit a snag when attempting to fire the click event on a date in the flatpickr calendar instance, which had the CSS class `flatpickr-day`. When selecting the element and triggering the `.click()` event, nothing was happening; the date was not selected, the flatpickr instance did not close, and the input remained empty.

<!--more-->

Through further investigation I found what the flatpickr calendar was doing. The actual calendar has a container element with the CSS class `dayContainer`. The `mousedown` event handler was attached to this element, instead of every individual `flatpickr-day` element, I assume to cut down on the number of bound events on the page. This event handler, via event propagation, checked that the `target` of the event was a `flatpickr-day` element, and if so it continued to propagate the event and select the date. When calling `.click()` on the `dayContainer` via JavaScript, the event propagation did not work correctly because the target was always just `dayContainer`, because there was no point of reference for where the mouse was clicking, so flatpickr could not determine what date was being selected.

Through inspection of flatpickr's own UI specs and some Googling around, I found the [MouseEvent]() class. You can manually create a MouseEvent, which is what is triggered by the browser whenever you click something with your mouse, using JavaScript. This is outlined in the MDN article [Creating and triggering events](https://developer.mozilla.org/en-US/docs/Web/Guide/Events/Creating_and_triggering_events) in detail, but what you need to do is create the `MouseEvent` then dispatch it to the desired element at the desired coordinates. This simulates the proper targeting and event bubbling/propagation. The reason you have to provide it the `x` and `y` coordinates of whatever you want to click on is that otherwise you end up with the same problem as before, where `event.target` is just `dayContainer` because nothing was _actually_ clicked on.

Here is an example of how I was choosing a specific date to pick, finding its position using `getBoundingClientRect()`, and then dispatching the `MouseEvent`.

```javascript
var dateTile     = document.querySelector('[aria-label="April 21, 2017"]'),
    datePosition = dateTile.getBoundingClientRect();

var event = new MouseEvent('mousedown', {
    'view': window,
    'bubbles': true,
    'cancelable': true,
    'screenX': datePosition.left,
    'screenY': datePosition.top
});

dateTile.dispatchEvent(event);
```

If you are working with PhantomJS or older browsers, you will need to use the deprecated [document.createEvent]() and [event.initMouseEvent]() functions instead like so. The [PhantomJS team are aware of this issue](https://github.com/ariya/phantomjs/issues/11289).

```
var mouseEvent = document.createEvent('MouseEvents');
mouseEvent.initMouseEvent('mousedown', true, true, window, 0, datePosition.left, datePosition.top);
```

There are also other events, like key presses, that can be dispatched in the same way. This worked great for my use case in the feature specs, and I hope anyone else trying to properly simulate a mouse click event in JavaScript finds it helpful too.