# frozen_string_literal: true

require 'fileutils'
require 'pathname'
require 'jekyll-last-modified-at'
require 'pry'

module Recents
  # Generate change information for all markdown pages
  class Generator < Jekyll::Generator
    def generate(site)
      site.collections["notes"].docs.each do |note|
        note.data['last_modified_at_str'] = Jekyll::LastModifiedAt::Determinator.new(site.source, note.path, '%FT%T%:z').to_s
      end
    end
  end
end
