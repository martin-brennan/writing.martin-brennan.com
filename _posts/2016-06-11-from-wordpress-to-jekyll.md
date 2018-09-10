---
title: From Wordpress to Jekyll
date: 2016-06-11T11:02:26+10:00
author: Martin Brennan
layout: post
permalink: /from-wordpress-to-jekyll/
---

This blog is now run on [Jekyll](https://jekyllrb.com/), and here’s why.

![Jekyll](/images/jekyll-and-hyde.jpg)

I got real tired of WordPress for the following reasons:

1. It’s slow, for a simple blog.
2. Reliance on a database.
3. General heavy-ness. I didn't really use most of its features, and it felt slow to navigate around the admin area.
4. Did I mention it’s slow?

I’ve toyed with the idea of moving this blog to Jekyll for a few years now but I felt like it wasn’t mature enough to handle the transition yet. I had fears and doubts about how it would handle SEO and analytics and whether I would lose any important functionality from plugins. Nothing could be further from the truth. Jekyll is now a robust tool for blogging or documentation, and is great for you if you like having more control over the format and output of your blog. I've compiled all of the helpful links I found when making the transition. <!--more-->

## Things that I’ve found to be great with Jekyll

1. Writing in Markdown. I find it much more easy and pleasant to use my favourite editor to write and edit posts in [Markdown](https://daringfireball.net/projects/markdown/) format rather than transposing them to Wordpress’ WYSIWYG editor.
2. Themes and layouts. These work in a similar way to WordPress themes but I thought it was much more simple, and not having to deal with PHP is a big plus. Just HTML & CSS with the Liquid templating engine and simple syntax.
3. Quick to build and easy to deploy. Jekyll just outputs your posts and pages as HTML pages alongside the CSS, image and JavaScript assets. It's just a simple static website at the end of the day.
4. Robust syntax highlighting built-in. This is especially important for a programming blog. Jekyll uses Rogue by default. Also it supports fenced code blocks!
5. Easy to reuse page components in the form of partials.
6. In built SASS pipeline and sane CSS defaults.
7. Any folders not prefixed with _ count as assets and can be referred to by their relative path when publishing your Jekyll site e.g. showing an image with a src of /images/example.png

## Exporting from Jekyll to Wordpress

I used the Wordpress to Jekyll exporter plugin for this and it worked great. All posts and pages were exported, along with things like tags and categories. I just had to clean up these few things:

1. Some of the links were messed up or had bad formatting
2. Code syntax highlighting was inconsistent, I had to go through the post files to apply the correct formatting.
3. Images still retain all of their garbage Wordpress CSS classes an wrapper divs, and I had to clean up image tags in general. The exporter does export all of your uploaded Wordpress images which is nice.

## Gains

Here are my performance gains from moving to Jekyll:

1. martin-brennan.com Wordpress - DOMContentLoaded 2.98s - Load 5.07s - 80 requests - 943kb
2. martin-brennan.com Jekyll    - DOMContentLoaded 1.01s - Load 2.27s - 10 requests - 167kb

## SEO

SEO is no problem with Jekyll thanks to the [jekyll-seo-tag](https://github.com/jekyll/jekyll-seo-tag) plugin. It inserts the required SEO meta tags as well as relevant Facebook and Twitter tags. It will automatically extract titles and a post excerpt but these can be overridden in the YAML front matter of the post. You just need to include the SEO tag in your head layout file.

```erb
{% raw %}{% seo %}{% endraw %}
```

Here is an example of the output:

```
{% seo %}
```

## Analytics and Adsense

For Google Analytics, you just need to insert the tracking code in your head layout file and it will be included on very single page, simple!

You need to do the same thing for your AdSense embed codes, simply put the code in the layout files where you want the ads to appear. You could put the actual ads in partials for more flexibility and simply include the partial wherever you need it like so:

```erb
{% raw %}{{ include adsense_horizontal.html }}{% endraw %}
```

## Pagination

Pagination was easy to set up as well. I used the [jekyll-paginate](https://github.com/jekyll/jekyll-paginate) plugin to set this up. All you have to do is set the number of posts per page you want to see in `_config.yml`.

```
paginate: 10
```

## Outcome & Useful Links

You'll have noticed that I've stripped the design of this site back to a very simple format for better clarity as well. Overall the experience of moving to Jekyll from Wordpress was really smooth and I wish I'd done it sooner! You can see the code and posts for this blog [over at GitHub](https://github.com/martin-brennan/martin-brennan.com).

I found these articles useful along the way (I set up Jekyll on a DigitalOcean Ubuntu droplet):

1. [How To Deploy Jekyll Blogs with Git](https://www.digitalocean.com/community/tutorials/how-to-deploy-jekyll-blogs-with-git)
2. [How to solve “/usr/bin/env: ruby_executable_hooks: No such file or directory”?](http://stackoverflow.com/questions/26247926/how-to-solve-usr-bin-env-ruby-executable-hooks-no-such-file-or-directory)
3. [How To Get Started with Jekyll on an Ubuntu VPS](https://www.digitalocean.com/community/tutorials/how-to-get-started-with-jekyll-on-an-ubuntu-vps)
