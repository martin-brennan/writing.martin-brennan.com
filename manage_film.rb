require "mini_magick"
require "yaml"
require "set"

FILM_DIR = "assets/film"
THUMBS_DIR = "assets/film/thumbnails"
YAML_PATH = "_data/film.yml"

class ImageOptimizer
  MAX_WIDTH = 600
  QUALITY = 80

  class << self
    def resize(content, final_filename, max_width = MAX_WIDTH, quality = QUALITY)
      img = MiniMagick::Image.read(content)
      w = img[:width]
      h = img[:height]

      if w > max_width
        img.resize "#{max_width}x"
      end

      img.quality quality.to_s if quality.to_i > 1 && quality.to_i < 100
      img.write("#{THUMBS_DIR}/#{final_filename}.jpeg")
      [w, h]
    end
  end
end

# Sync logic only runs when this file is executed directly,
# not when required by instafilm.rb.
if __FILE__ == $PROGRAM_NAME
  entries = YAML.load_file(YAML_PATH)
  known_slugs = entries.map { |e| e["slug"] }.to_set
  max_order = entries.map { |e| e["order"] }.compact.max || 0

  thumbnails_generated = 0
  new_yml_entries = []

  Dir.foreach(FILM_DIR) do |filename|
    next if filename == "." || filename == ".."
    full_path = "#{FILM_DIR}/#{filename}"
    next if File.directory?(full_path)
    ext = File.extname(filename)
    next unless %w[.jpeg .jpg].include?(ext.downcase)

    slug = File.basename(filename, ext)
    thumb_path = "#{THUMBS_DIR}/#{slug}.jpeg"
    in_yml = known_slugs.include?(slug)
    has_thumb = File.exist?(thumb_path)

    next if in_yml && has_thumb

    if has_thumb
      img = MiniMagick::Image.open(full_path)
      w = img[:width]
      h = img[:height]
    else
      w, h = ImageOptimizer.resize(File.read(full_path), slug)
      thumbnails_generated += 1
      puts "Thumbnail: #{slug} (#{w}x#{h})"
    end

    unless in_yml
      max_order += 1
      new_yml_entries << { slug: slug, width: w, height: h, order: max_order }
    end
  end

  if new_yml_entries.any?
    new_block = new_yml_entries.sort_by { |e| -e[:order] }.map { |e|
      <<~YAML
        - slug: "#{e[:slug]}"
          title: ""
          description: ""
          width: #{e[:width]}
          height: #{e[:height]}
          order: #{e[:order]}

      YAML
    }.join

    text = File.read(YAML_PATH)
    first_entry_idx = text.index(/^- slug:/)
    abort "Could not find first entry in #{YAML_PATH}" unless first_entry_idx
    text = text[0...first_entry_idx] + new_block + text[first_entry_idx..]
    File.write(YAML_PATH, text)
  end

  puts ""
  puts "Summary:"
  puts "  Thumbnails generated: #{thumbnails_generated}"
  puts "  New yml entries:      #{new_yml_entries.size}"
  if new_yml_entries.any?
    puts ""
    puts "Fill in title/description for these new entries in #{YAML_PATH}:"
    new_yml_entries.each { |e| puts "  - #{e[:slug]} (order: #{e[:order]})" }
  end
end
