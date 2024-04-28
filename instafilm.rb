# frozen_string_literal: true

require "pry"
require "httparty"
require_relative "./film_thumbnails.rb"

INSTA_API = "https://graph.instagram.com/"

args = ARGV

# Go to https://developers.facebook.com/apps to regenerate this
# using the Instagram Basic Display API
ACCESS_TOKEN = ENV["INSTAGRAM_LONG_LIVED_ACCESS_TOKEN"]

def strip_instagram_details(caption)
  # Strip hashtags and mentions, not needed on this site.
  caption
    .gsub(/#[a-z0-9_]+/i, "")
    .gsub(/@[a-z0-9_]+/i, "")
    .squeeze(" ")
    .gsub(" .", ".")
    .strip
end

if args[0] == "get_media"
  puts "Getting all media"
  media_response =
    HTTParty.get(
      "#{INSTA_API}me/media?fields=id,media_type,media_url,caption&access_token=#{ACCESS_TOKEN}"
    )
  puts media_response.code
  File.write("./instagram_media_response.json", media_response.body)
elsif args[0] == "read_cached_media"
  all_images = JSON.parse(File.read("./instagram_media_response.json"))["data"]
  all_images.each do |image|
    caption = strip_instagram_details(image["caption"])
    puts "#{caption}: "
    puts "- #{image["media_url"]}"
  end
elsif args[0] == "refresh_access_token"
  puts "Refreshing ACCESS_TOKEN"
  response =
    HTTParty.get(
      "#{INSTA_API}refresh_access_token?grant_type=ig_refresh_token&access_token=#{ACCESS_TOKEN}"
    )
  puts response.code
elsif args[0] == "process_images"
  all_images = JSON.parse(File.read("./instagram_media_response.json"))["data"]

  # Reverse because the most recent images come first usually -- we want to
  # start from 0 for the oldest.
  all_images.reverse.each_with_index do |image, image_idx|
    url = image["media_url"]
    filename = "synced-film-#{image_idx}"

    puts "Downloading image from #{url}"
    Tempfile.create do |file|
      file.write HTTParty.get(url).body

      puts "Copying downloaded image to assets/film/#{filename}.jpeg"
      FileUtils.cp(file.path, "assets/film/#{filename}.jpeg")
    end

    puts "Optimizing image"
    ImageOptimizer.resize(File.read("assets/film/#{filename}.jpeg"), filename)
    puts "Done optimizing"
  end
elsif args[0] == "generate_markdown_files"
  all_images = JSON.parse(File.read("./instagram_media_response.json"))["data"]

  all_images.reverse!

  synced_film = []
  Dir.each_child("assets/film") do |fn|
    synced_film << fn if fn.include?("synced-")
  end

  # Otherwise the sort goes like 0, 1, 10, 11
  synced_film = synced_film.sort_by { |name| name[/\d+/].to_i }

  synced_film.each_with_index do |filename, idx|
    caption = strip_instagram_details(all_images[idx]["caption"])
    contents = <<~FM
      ---
      title: XXXXSYNC
      layout: film
      order: #{idx + 10_000}
      ---

      #{caption}
    FM

    File.write("_film/#{filename.gsub(".jpeg", ".md")}", contents)
  end
end

# For each image from insta:
#
# * Download to /tmp using the media_url
# * Use the imagemagick thumbail code to generate a thumbnail and output to /assets/film/thumbnails/name.jpeg
# * Copy the image itself to /assets/film/thumbnails/name.jpeg
# * Generate a note in the _film/filename.md directory with YML front matter, filename.md should be the same as name.jpeg and numbered 001-image.jpeg. Note should use caption above
# * Title for note will need to be added manually, as will any other lens/film details, but likely will just leave that in the caption for laziness
