require 'open-uri'
require 'mini_magick'

class ImageOptimizer
  class << self
    def resize(content, width, height, quality, final_filename)
      if Gem.win_platform?
        MiniMagick.cli_path = "C:\\Program Files\\ImageMagick-7.1.0-Q16-HDRI\\"
      end
      img = MiniMagick::Image.read(content)
      w_original = img[:width].to_f
      h_original = img[:height].to_f

      # check proportions
      op_resize = if w_original * height < h_original * width
                    "#{width.to_i}x"
                  else
                    "x#{height.to_i}"
                  end

      img.combine_options do |i|
        i.resize(op_resize)
        i.gravity(:center)
        i.quality quality.to_s if quality.to_i > 1 && quality.to_i < 100
        i.crop "#{width.to_i}x#{height.to_i}+0+0!"
      end

      img.write("assets/film/thumbnails/#{final_filename}.jpg")
    end
  end
end

WIDTH = 600
HEIGHT = 600
QUALITY = 80

Dir.foreach("assets/film") do |filename|
  next if File.directory?(filename)
  next if filename == "thumbnails"
  puts "film filename: #{filename}"
  final_filename = filename.gsub(File.extname(filename), "")
  content = open("assets/film/#{filename}")
  ImageOptimizer.resize(content, WIDTH, HEIGHT, QUALITY, final_filename)
end
