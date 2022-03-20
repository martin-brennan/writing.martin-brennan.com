require 'liquid'
require 'uri'

# Capitalize all words of the input
module Jekyll
  module CapitalizeAll
    def capitalize_all(words)
      return '' if words.nil?
      if words.is_a? Array
        words = words.map do |word|
          word.split(/[\s,_]/).map(&:capitalize).join(' ')
        end
        return words
      else
        return words.split(' ').map(&:capitalize).join(' ')
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::CapitalizeAll)