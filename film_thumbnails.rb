require "open-uri"
require "mini_magick"

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
      img.write("assets/film/thumbnails/#{final_filename}.jpeg")
      [w, h]
    end
  end
end

Dir.foreach("assets/film") do |filename|
  next if File.directory?(filename)
  next if filename == "thumbnails"
  ext = File.extname(filename)
  next if !%w[.jpeg .jpg].include?(ext)
  final_filename = filename.gsub(ext, "")
  content = open("assets/film/#{filename}")
  w, h = ImageOptimizer.resize(content, final_filename)
  puts "#{final_filename}: #{w}x#{h}  (width: #{w}, height: #{h})"
end
