#!/bin/ruby

title_filename = ARGV[0]
stories = ARGV[1]
tags = ARGV[2]
title = title_filename.gsub("_", " ").split(" ").map(&:capitalize).join(" ")

puts "Creating #{title} (#{title_filename}) note...reference with [[#{title_filename}|#{title}]]"

File.open("_notes/#{title_filename}.md", 'w') { |fo| fo.puts "---
title: #{title}
tags: [#{tags}]
stories: [#{stories}]
---" }