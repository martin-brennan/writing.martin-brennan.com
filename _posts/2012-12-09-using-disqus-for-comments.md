---
id: 203
title: Using Disqus For Comments
date: 2012-12-09T21:52:31+10:00
author: Martin Brennan
layout: post
guid: http://www.martin-brennan.com/?p=203
permalink: /using-disqus-for-comments/
dsq_thread_id:
  - 965596529
iconcategory:
  - development
mashsb_shares:
  - 0
mashsb_timestamp:
  - 1464933347
mashsb_jsonshares:
  - '{"total":0}'
categories:
  - Development
  - Observation
tags:
  - Amazon
  - Amazon EC2
  - Comments
  - Discussion
  - Disqus
  - EC2
  - Wordpress
---
I was recently creating a status blog for our web application and services at work to inform users of potential downtime and the current service status, and as a microblogging platform where we could present new features of the application. We decided to use [WordPress](http://www.wordpress.org), naturally, and we set it up on a new [Amazon EC2](http://aws.amazon.com/ec2/) instance using a public [WordPress AMI](http://bitnami.org/stack/wordpress). As I was styling the website, I wasn&#8217;t really getting anywhere with the design of the comments section, which is a problem I often have. Having seen [Disqus](http://www.disqus.com) being used much more frequently on prominent websites, including its recent adoption as comment provider by the [Envato tutsplus](https://tutsplus.com/) network, I decided to start using Disqus for comments on this new blog. What I found was far better than I had ever expected.<!--more-->

So much better, in fact, that I have also started using Disqus for comments on this blog. In case you had been living on Mars or something, Disqus is a real-time community discussion system that replaces traditional comment systems in different blogging platforms and websites and attempts to centralize all comments and discussions in the one place, something it does very, very well. Disqus supports [WordPress](http://www.wordpress.org), [tumblr](http://tumblr.com), [Drupal](http://www.drupal.org), [Blogger](http://www.blogger.com), [Typepad](http://www.typepad.com), [Joomla](http://www.joomla.org) and can be integrated into any website page using HTML and JavaScript.

## Let&#8217;s Discuss Disqus

One of the main advantages I found with using Disqus for comments is that it is incredibly easy to set up. After registering an account on Disqus, all you have to do is create a &#8220;site&#8221; by entering the domain you would like to run Disqus on, a name for the site and also a shortname for the site which will appear when moderating comments in your Disqus dashboard. From there, it was as simple as installing the Disqus plugin in my WordPress site and selecting the site that I set up as the place to store comments. There is also an option to export your old comments to Disqus so they are still seen and preserved when you migrate.

![disqus site](/images/disqussite.png)

Disqus also has a lot of customisation in the site settings that you can use to regulate how your community comments on your site. You can set rules for Guest commenting, pre-moderation, attachments, flagging, automatic closing and rules for links in comments. You can also add word filters to remove nasty words from comments, and Disqus even provides Akismet integration, so you can use your existing API key. You can further manage your comments by adding other moderators and more trusted domains can be added to access the same comments on other websites that you have.

Also, Disqus has social media integration out of the box in the form of sharing discussions and the ability to connect via Facebook, Twitter, Google+, Disqus or as a Guest. A user doesn&#8217;t have to sign up for Disqus to comment on your site, they can simply use one of their existing social media accounts! If a user does not want to use one of their established social media accounts then they can just post as a Guest, which is fantastic because people can still join in the discussion without having to sign in to anything!

## Look and Feel

Embedded in your blog, Disqus looks amazing. It spans the entire width of the container that your content resides in, and the colour scheme and typeface automatically adapt to your website&#8217;s style. The user interface is beautiful and easy to use, and I love the font that they use, which by the looks of it is Helvetica Neue. From the comment box, users can also share or favourite the discussion, and see other discussions on the same site. I was a bit worried when I was about to start using Disqus for comments on this site that code formatting would not be natively supported. Boy was I wrong! [Disqus natively supports code syntax highlighting](http://help.disqus.com/customer/portal/articles/665057 "Disqus Syntax Highlighting"), and allows the use of certain HTML tags to style elements.

![disqus comment](/images/disquscomment.png)

## Closing Thoughts

I&#8217;m really looking forward to using Disqus for comments heavily in my own website and for other projects because it is a great, easy to use system that looks awesome and is incredibly easy to set up, customise and moderate. Disqus is the wave of the future for discussions and comments for any web site, small to large!
