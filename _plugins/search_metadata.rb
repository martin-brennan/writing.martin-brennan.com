require 'liquid'
require 'uri'

# Capitalize all words of the input
module Jekyll
  module SearchMetadata
    def search_metadata(words)
      return '' if words.nil?
      words = words.map do |word|
        word.split(/[\s,_]/).map(&:capitalize).join(' ')
      end
      return words.join(', ')
    end
  end
end

Liquid::Template.register_filter(Jekyll::SearchMetadata)