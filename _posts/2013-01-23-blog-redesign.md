---
id: 248
title: Blog Redesign
date: 2013-01-23T20:31:55+10:00
author: Martin Brennan
layout: post
guid: http://www.martin-brennan.com/?p=248
permalink: /blog-redesign/
iconcategory:
  - design
dsq_thread_id:
  - 1042977533
mashsb_shares:
  - 0
mashsb_timestamp:
  - 1464920086
mashsb_jsonshares:
  - '{"total":0}'
categories:
  - Design
  - Writing
tags:
  - CSS
  - Design
  - SASS
  - Theme
---

{% include deprecated.html message="I've redesigned again since this article, though you may find some of the links helpful." cssclass="deprecated" %}

For the past week and a bit I’ve been redesigning martin-brennan.com for a fresh look and feel, and today I’m launching the new design! Let me know what you think on twitter [@mjrbrennan](htttp://twitter.com/mjrbrennan) or in the comments, or take a bit more time to bask in my new design and read about my process in the article!

<!--more-->

## Why Redesign?

I guess I better start with why I did this redesign. I thought that my original design was growing a bit tired and old despite only launching this blog about 8 months ago. The main thing that bothered me was the lack of colour, and the fact that it didn’t work extremely well on mobile devices. Plus I just felt like it and it’s my blog not yours so there!

## Mobile-First Design

I decided this time to design the site using [mobile-first design](http://weblogs.java.net/blog/manningpubs/archive/2012/11/14/foundations-mobile-first-design), so I could give it a go and see if I liked it or not. I bought a couple of books on the subject as well as responsive design from [A Book Apart](http://www.abookapart.com/); [Mobile First](http://www.abookapart.com/products/mobile-first) by [Luke Wroblewski](https://twitter.com/lukew) and [Responsive Web Design](http://www.abookapart.com/products/responsive-web-design) by [Ethan Marcotte](https://twitter.com/beep). I haven’t read all the way through each one yet, but so far they are fantastic books and I recommend you get them!

Mobile-first and responsive web design worked out very well for me considering this is the first time I’ve used them. I designed the blog for mobile first, then tablet, then desktop and then coded it the other way around, using [media queries](http://css-tricks.com/snippets/css/media-queries-for-standard-devices/) for the responsiveness on mobile devices. You can visit [mediaqueri.es](http://mediaqueri.es/) to see some fantastic examples of media queries in action!

I found that it resulted in a much simpler and friendlier design using mobile-first because it forced me to think of what was really required, and then to add more content as I had more space to work with. Having a good idea of my mobile design was great too as in the past it was mainly an afterthought for me.

## Redesign

For my redesign, I wanted to focus on having a very clean design with a lot of colours and whitespace, with a lighter tone than my previous design. I achieved this by using bright, eye catching link colours with circles containing an icon for each post category. I then paired this with simple black text on a white background, and ensured everything was nice and evenly spaced.

### Fonts

I used Helvetica Neue for the heading fonts, because I love it and I’ve been wanting to use it in a blog for a while. It looks great in bold, hence the reason it suits headings so well. For the body font I used a great free-ish web font called [bariol](http://www.bariol.com/). I say free-ish because while you can pay for the regular and italic versions with a tweet, you must pay for the thin, light and bold weights with real money. It only cost €3.00 though so I wasn’t too bent out of shape about buying it, and I’m really happy with how it looks.

I used a great service called [Font Squirrel](http://www.fontsquirrel.com) to convert bariol to a web font. Font Squirrel converts your font to .svg, .woff, .ttf and .otf files and gives you the CSS required to include it in your project, and is free to use. Just go to the @font-face generator page to get started.

### Icons

I’ve used icons in my redesign to represent categories so I could have a more visual representation of them and to include more colour in the page. I tried at first to use [CSS sprites](http://css-tricks.com/css-sprites/) with some luck, which I generated with the excellent [Sprite Cow](http://www.spritecow.com/) tool, but was disappointed with the results on retina displays.

However, I remembered about an app called [IcoMoon](http://www.icomoon.io) after reading an article, which provides packs of icons that you can group together and download as an [icon font](http://css-tricks.com/examples/IconFont/). I did not know, however, that you can upload SVG vector images to IcoMoon and create your own custom icon font! I did this with my category icons and was very happy with the results; IcoMoon even provides you with the @font-face CSS to include your new icon font in your project.

### Colours

I made _everything_ more colourful, even my code snippets! I’ve started using [Monokai Bright](http://studiostyl.es/schemes/monokai-bright-sublime) in Sublime Text 2 and Visual Studio, and I’m loving how bright and colourful it is, so I based a lot of my colours on that. Hopefully it makes my blog a bit more visually appealing and interesting to read.

### SASS

I used [SASS](http://sass-lang.com/) & .scss files in my old design, but I didn’t really use them to their full potential. I did this time however; I split up my CSS into variables.scss, mixins.scss, fonts.scss, media-queries.scss and screen.scss, which made it much easier to organise my CSS. I also used mixins a lot more, and I love how powerful they are. I can’t wait to incorporate SASS into my workflow at work, it’s such a great tool and it’s the future of CSS.

## Final Thoughts

Overall, I really enjoyed this redesign and I’ve learned a bit more about mobile-first and responsive design along the way. Make sure you check out the [About](/), [Archive](/archive) and [Projects](/projects) pages as well, as I’ve changed them around a bit too. Hope everyone likes it, and if you have any feedback leave a comment or send me a [tweet](http://twitter.com/mjrbrennan "mjrbrennan on twitter")!
