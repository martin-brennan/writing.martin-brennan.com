require "open-uri"
require "mini_magick"

class ImageOptimizer
  WIDTH = 600
  HEIGHT = 600
  QUALITY = 80

  class << self
    def resize(
      content,
      final_filename,
      width = WIDTH,
      height = HEIGHT,
      quality = QUALITY
    )
      # if Gem.win_platform?
      #   MiniMagick.cli_path = "C:\\Program Files\\ImageMagick-7.1.0-Q16-HDRI\\"
      # end
      img = MiniMagick::Image.read(content)
      w_original = img[:width].to_f
      h_original = img[:height].to_f

      op_resize =
        if w_original * height < h_original * width
          "#{width.to_i}x"
        else
          "x#{height.to_i}"
        end

      img.combine_options do |combiner|
        combiner.resize(op_resize)
        combiner.gravity(:center)
        combiner.quality quality.to_s if quality.to_i > 1 && quality.to_i < 100
        combiner.crop "#{width.to_i}x#{height.to_i}+0+0!"
      end

      img.write("assets/film/thumbnails/#{final_filename}.jpeg")
    end
  end
end

Dir.foreach("assets/film") do |filename|
  next if File.directory?(filename)
  next if filename == "thumbnails"
  next if filename.include?("synced-film")
  ext = File.extname(filename)
  next if !%w[.jpeg .jpg].include?(ext)
  puts "film filename: #{filename}"
  final_filename = filename.gsub(ext, "")
  content = open("assets/film/#{filename}")
  ImageOptimizer.resize(content, final_filename)
end
