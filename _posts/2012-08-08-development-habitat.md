---
id: 77
title: Development Habitats
date: 2012-08-08T22:36:08+10:00
author: Martin Brennan
layout: post
guid: http://www.martin-brennan.com/?p=77
permalink: /development-habitat/
dsq_thread_id:
  - 970946862
iconcategory:
  - writing
mashsb_shares:
  - 0
mashsb_timestamp:
  - 1464946190
mashsb_jsonshares:
  - '{"total":0}'
categories:
  - Share
  - Writing
tags:
  - Beanstalk
  - Development Environment
  - Dropbox
  - Evernote
  - Git
  - Github
  - Illustrator
  - Macbook Air
  - MAMP
  - Photoshop
  - Sublime Text 2
  - Transmit
---

{% include deprecated.html message="This article shows its age. The only things I use here now are GitHub and Dropbox." cssclass="deprecated" %}

One of the things I find fascinating about being in a community of web developers is the huge difference between the workspaces, development environments and software preferences of individual developers. In this article, I’ll go over some of the applications, web services and hardware that I use when developing in my spare time. Please note that I am not in any way endorsed by or affiliated with any of these companies, I just love their products and services!<!--more-->

## Hardware

The hardware makes what we do possible, so it makes sense that we like whatever it is we are working on. We need something fast, reliable and stylish to facilitate our passion for programming. Otherwise, it all just becomes a chore to complete even the simplest of tasks.

I used to work on a Windows PC/Laptop until around this time last year, when I decided that I would give Mac a try. I was enamoured with the Macbook Air as a web development tool, after reading Jonathan Christopher of Monday By Noon’s [article](http://mondaybynoon.com/20110712/macbook-air-web-development/).

I slapped down a chunk of change on a 13&#8243; Macbook Air with all the trimmings; 1.7 GHz i7, 4GB RAM and 256GB SSD. It was definitely one of the best purchases I’ve ever made. It’s superfast, extremely lightweight and portable, stylish, and a joy to work on. I enjoy working on a Mac over Windows at home, but I have nothing against Windows, I still use it daily at work.

## Apps and Software

There are only a couple of applications that I use in my workflow that I don’t count among web apps. The first of these applications is as [“feymous” as Mr. T](http://youtu.be/BmQGxzIUVbk?t=3m40s); Sublime Text 2.

### Sublime Text 2

I’ve used a few different editors and IDEs in my relatively short time as a web developer, and I can say without hyperbole that Sublime Text 2 blows them all out of the water.

Up until recently, I used Coda as my editor of choice. It’s a great IDE and it served me well for a while, but I was always hearing whispers of Sublime Text 2, so I thought I’d give it a try one day, and since then I’ve never looked back.

It’s main strengths are:

**It’s fast** &#8211; Sublime is extremely fast to open and load files, much quicker than any other editor I’ve used. The only thing that is comparable is opening a file in Notepad++ or a simple text editor.

**It’s pretty** &#8211; Sublime has a very nice, minimalistic interface that I really enjoy working with, as well as a host of syntax colouring themes. I use Slush & Poppies as my theme of choice.

**It’s extensible** &#8211; There are a boatload of plugins available for Sublime Text 2, most of which can be installed from within the program using the Command Palette, which brings me to my next point.

**It has the Command Palette** &#8211; The Command Palette is an incredibly useful tool in Sublime Text 2. It lets you run macros and commands, quickly insert snippets, manage your plugins and a whole bunch of other cool stuff.

Of course I’m just scratching the surface here, head over to [their website](http://www.sublimetext.com/) to see the great features for yourself.

### MAMP

MAMP stands for Mac, Apache, MySQL, PHP. It is one of the most indispensable tools you can have for local development and testing. I use MAMP to locally test out and develop my WordPress themes, and I also use it for any sort of PHP development. If you’re doing any variety of applications that are PHP and MySQL based on a Mac, start using MAMP [now](http://www.mamp.info/en/index.html)!

### Adobe Photoshop and Illustrator

While I don’t care at all for Adobe’s main web development tool, Dreamweaver, I couldn’t live without it’s two major graphical players.

I use Photoshop extensively for design and for website mock-ups. I used to use it back in my 3D days to make a lot of textures, so over time I’ve become very comfortable in it.

Illustrator I mainly use for creating any icons, or to create shapes for use in Photoshop because I hate Photoshop’s pen and shape tools. For vector, Illustrator is king.

## Web Services and Applications

There are a few web services that I love to use when developing. The main web services I use are for storage and source control, and some that help me stay organised.

### Dropbox

If you’ve been living under a rock, Dropbox is an online file storage service that is version controlled, and syncs to all of your different devices.

I use Dropbox to store all of my projects, code files and designs. Basically anything related to web development, and it all stays synced for me. I also store any articles I write on Dropbox to keep them safe and version controlled, and for whenever I get the urge to write on the go. It’s great for sharing as well; I share content with my friend on there so we can collaborate on our other blog.

Space starts out at 2GB for the free tier, but it’s pretty easy to score some more, and there are always forums that keep up Dropbox recommendation chains where you can get extra space for free. Try Dropbox [here](http://www.dropbox.com).

### Github

You may of heard of this little application. I love using Git and [Github](http://www.github.com) for version control of my projects. I really like the design of the Github website too, it makes a lot of potentially overwhelming information very easy to access and use.

I found it a little hard to understand and set up when I first started using Git, so here is a handy guide on [their website.](https://help.github.com/articles/set-up-git)

### Evernote

I find [Evernote](http://evernote.com/) really handy for squirrelling away tutorials, articles and resources to be used at a later date. It’s especially useful when you know you’ll be needing something down the line but it isn’t particularly useful for you now. Combined with the [Chrome extension](https://chrome.google.com/webstore/detail/pioclpoplcdbaefihamjohnefbikjilc), saving content for later is a breeze.

### Beanstalk

After hearing a couple of good things about it and watching [Chris Coyier’s screencast](http://css-tricks.com/video-screencasts/109-getting-off-ftp-and-onto-git-deployment-with-beanstalk/) about using it for deployment, I have adopted a [Beanstalk](http://beanstalkapp.com/) and Git deployment workflow for development.

Beanstalk is similar to Github in that it hosts Git repositories. What sets it apart though is its ability to perform post-commit deployment of changes to an external web server. So if I make a change on one of my blogs, I just test it out locally using MAMP, commit the changes, push the changes to Beanstalk and it handles the rest. No more faffing about with FTP, it’s extremely easy to set up and use and is now a major part of my workflow.

### Transmit

When I do have to use FTP, I like to use [Transmit](http://panic.com/transmit/) from Panic, the creators of Coda. I really like its interface, and its support of FTP, SFTP and Amazon S3. I also like the fact that it maintains connection to the server and very rarely drops it, which sets it apart from a lot of other FTP programs I’ve used.

## What about you?

Whelp, that’s pretty much it for what I use at home. I haven’t gone over what I use at work because it’s all very boring and droll Microsoft products for the most part, and I have a lot more fun working on stuff at home using a Mac.

So what do you use? Let me know in the comments, like I said I love hearing about what other developers use and incorporating parts of their web development workflow into my own.
