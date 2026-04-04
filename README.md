This is the source repo for https://writing.martin-brennan.com , which at the time of writing this README looks like this:

![writing.martin-brennan.com homepage](assets/writing_home.png)

This website serves as a collection of my writing, including:

* Worldbuilding for the fictional worlds and stories I create
* Fully formed essays and traditional blog posts
* Thoughts about books, films, music, and other art

The blog portion of my website can be found at https://writing.martin-brennan.com/blog/, though admittedly entries are sparse.

----

The Jekyll template used to power this website is based on [Setting up your own digital garden with Jekyll](https://maximevaillancourt.com/blog/setting-up-your-own-digital-garden-with-jekyll), though heavily modified and styled, which supports `[[Roam/Obisidian style links]]` which generate backlinks as well as a node graph.

I use this extensively inside the `_notes` directory to make links between worldbuilding and characters for my stories. Links to the current article are displayed in the sidebar:

![writing.martin-brennan.com sidebar](assets/writing_sidebar.png)

---

# Instructions to self

### Adding film images

1. Drop the full-size image in `assets/film/` (e.g. `my-photo.jpeg`)
2. Run `ruby film_thumbnails.rb` to generate thumbnails — this also outputs the image dimensions:
   ```
   my-photo: 1080x1364  (width: 1080, height: 1364)
   ```
3. Add an entry to `_data/film.yml` with the dimensions from step 2:
   ```yaml
   - slug: my-photo
     title: My Photo
     description: "A description. Shot on Canon AE-1 with Portra 400."
     width: 1080
     height: 1364
     order: 10025
   ```
4. Set `order` higher than the current max to have it appear first in the gallery. Optional fields: `camera`, `lens`, `stock`, `approx_date`.