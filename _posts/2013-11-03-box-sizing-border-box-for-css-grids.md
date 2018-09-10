---
id: 382
title: Box-Sizing Border-Box for CSS Grids
date: 2013-11-03T12:18:13+10:00
author: Martin Brennan
layout: post
guid: http://www.martin-brennan.com/?p=382
permalink: /box-sizing-border-box-for-css-grids/
iconcategory:
  - design
dsq_thread_id:
  - 1931230816
mashsb_shares:
  - 0
mashsb_timestamp:
  - 1464920030
mashsb_jsonshares:
  - '{"total":0}'
categories:
  - Design
  - Share
tags:
  - border-box
  - box-sizing
  - CSS
  - framework
  - grid
---
I was working on a grid system in CSS for a style framework I&#8217;m making for work, and I ran into a few problems when styling the grid. Specifically, I was having trouble with aligning all of the columns side-by-side while simultaneously giving each column sufficient padding. There is a CSS property called `box-sizing`, which has a default value of `content-box`. The problem with this is that for block elements such as `divs`, properties like borders and padding **add width** to the element, even if it already has a fixed width. This is particularly troublesome with grids, because we need to have each column the correct width regardless of padding applied to it.<!--more-->

Thankfully, there is another value that can be used for the `box-sizing` property called `border-box`, which ensures the element that it is applied to **stays the same width**, regardless of any padding or borders applied to it. Chris Coyier has a great article on how this box model applies to grids:

<a href="http://css-tricks.com/dont-overthink-it-grids/" title="Don't Overthink it Grids by Chris Coyier" target="_blank">Don&#8217;t Overthink it Grids by Chris Coyier</a>

And Paul Irish also has an in-depth explanation about the box model and the usage border-box. The article is a great read and lists the pros of using this property:

<a href="http://www.paulirish.com/2012/box-sizing-border-box-ftw/" title="* { Box-sizing: Border-box } FTW" target="_blank">* { Box-sizing: Border-box } FTW</a>