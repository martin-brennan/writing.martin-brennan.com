---
layout: page
title: Home
id: home
permalink: /
---

<div class="home">
<div class="home__content" markdown="1">
# Ah, a visitor from a distant land!

Welcome, weary traveller. Take a seat, drink some water. You must be wondering what this place is. Answers will come in due time.

<div class="backlink-box">
You'll be here for some time. Why not begin by reading about my major projects on my [[Works]] page? Or perhaps you'd like to browse the [[Library]], or read a few posts on my [[Blog]]? If you need help with navigating this site, step on over to the [[Arcana]] page, or [[Search]].
  <div class="shortcut-hint shortcut-hint--with-top-margin">
  Psst...press <code>Ctrl</code>+<code>?</code> to be transported to the search page magically ✨
  </div>
</div>

My apologies, I do forget my introductions sometimes. I am Martin Brennan, the keeper of this codex. I am a writer, and above all I enjoy writing genre fiction. I write horror, sci-fi, fantasy, western, and everything else in-between, first in longhand or at the typewriter, then processed into the devil-machine.

This website serves as a collection of my writing. Words, as you well know, are unruly and must be pruned regularly, lest they strangle an unwary writer. This codex has many fragments, including:

* Worldbuilding for the fictional worlds and stories I create
* Fully formed essays and traditional blog posts
* Thoughts about books, films, music, and other art

We must remember to honour those masters who came before us. The authors that inspire me and prompt me to do better are Cormac McCarthy, Stephen King, J. R. R. Tolkien, Hunter S. Thompson, John Steinbeck, and Kurt Vonnegut.

I apologise, but I must attend to my [[The Thaw|current manuscript]] now. It's quite combative, and needs a stern talking-to every now and then. You may find me [@mjrbrennan](https://twitter.com/mjrbrennan) or email me at [mjrbrennan@gmail.com](mailto:mjrbrennan@gmail.com) if you have further queries.

</div>
  <div class="home__side">
    <img alt="Desert with cactii. View Along the Gila. Cereus Giganteus. The botanical works of the late George Engelmann, collected for Henry Shaw, esq." src="/assets/cactusdesert.jpg" />

    <div markdown="1" class="latest-updates">
  
<div markdown="1" class="latest-blog">
#### Latest blog posts

<ul>
{% for post in site.posts limit: 3 %}
  <li><a class="internal-link" href="{{ post.url }}">{{ post.title | truncate: 20 }}</a><br/>(<time class="posttime" datetime="{{ post.date | date_to_xmlschema }}" itemprop="datePublished">{{ post.date | date: "%B %-d, %Y" }}</time>)</li>
{% endfor %}
</ul>
</div>

<div markdown="1"  class="latest-notes">
#### Recently changed notes

<ul>
{% assign sorted_notes = site.notes | sort: 'last_modified_at_str' | reverse %}
{% for post in sorted_notes limit: 3 %}
  <li><a class="internal-link" href="{{ post.url }}">{{ post.title | truncate: 20 }}</a><br/>(<time class="posttime" datetime="{{ post.last_modified_at | date_to_xmlschema }}" itemprop="datePublished">{{ post.last_modified_at | date: "%B %-d, %Y" }}</time>)</li>
{% endfor %}
</ul>
</div>
  </div>
</div>

