require 'liquid'
require 'uri'

# Capitalize all words of the input
module Jekyll
  module AppearsIn
    def appears_in(stories)
      story_links = stories.map do |s|
        "<a class=\"internal-link\" href=\"/#{s.gsub("_", "-")}\">#{s.gsub("_", " ").split(" ").map(&:capitalize).join(" ")}</a>"
      end
      <<~HTML
        <div class="appears-in">
        Appears in #{story_links.join(", ")}
        </div>
      HTML
    end
  end
end

Liquid::Template.register_filter(Jekyll::AppearsIn)