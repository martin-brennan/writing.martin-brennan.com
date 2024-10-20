# frozen_string_literal: true
class BidirectionalLinksGenerator < Jekyll::Generator
  def generate(site)
    graph_nodes = []
    graph_edges = []

    all_notes = site.collections["notes"].docs
    all_films = site.collections["film"].docs
    all_pages = site.pages
    all_posts = site.posts

    all_nodes = all_notes + all_films + all_posts # defining what should be visualized in the graph
    all_docs = all_notes + all_pages + all_films + all_posts # ... and where bidirectional links are generated

    link_extension = !!site.config["use_html_extension"] ? ".html" : ""

    # Convert all Wiki/Roam-style double-bracket link syntax to plain HTML
    # anchor tag elements (<a>) with "internal-link" CSS class
    all_docs.each do |current_note|
      all_docs.each do |note_potentially_linked_to|
        title_from_filename =
          File
            .basename(
              note_potentially_linked_to.basename,
              File.extname(note_potentially_linked_to.basename)
            )
            .gsub("_", " ")
            .gsub("-", " ")
            .capitalize

        filename =
          File.basename(
            note_potentially_linked_to.basename,
            File.extname(note_potentially_linked_to.basename)
          )

        new_href =
          "#{site.baseurl}#{note_potentially_linked_to.url}#{link_extension}"
        anchor_tag = "<a class='internal-link' href='#{new_href}'>\\1</a>"

        # Replace double-bracketed links with label using note title
        # [[A note about cats|this is a link to the note about cats]]
        current_note.content.gsub!(
          /\[\[#{title_from_filename}\|(.+?)(?=\])\]\]/i,
          anchor_tag
        )
        current_note.data["excerpt"]&.content&.gsub!(
          /\[\[#{title_from_filename}\|(.+?)(?=\])\]\]/i,
          anchor_tag
        )

        # Replace double-bracketed links with label using note filename
        # [[cats|this is a link to the note about cats]]
        current_note.content.gsub!(
          /\[\[#{note_potentially_linked_to.data["title"]}\|(.+?)(?=\])\]\]/i,
          anchor_tag
        )
        current_note.data["excerpt"]&.content&.gsub!(
          /\[\[#{note_potentially_linked_to.data["title"]}\|(.+?)(?=\])\]\]/i,
          anchor_tag
        )

        # Replace double-bracketed links with label using note filename
        # [[cats|this is a link to the note about cats]]
        current_note.content.gsub!(
          /\[\[#{filename}\|(.+?)(?=\])\]\]/i,
          anchor_tag
        )
        current_note.data["excerpt"]&.content&.gsub!(
          /\[\[#{filename}\|(.+?)(?=\])\]\]/i,
          anchor_tag
        )

        # Replace double-bracketed links using note title
        # [[a note about cats]]
        current_note.content.gsub!(
          /\[\[(#{note_potentially_linked_to.data["title"]})\]\]/i,
          anchor_tag
        )
        current_note.data["excerpt"]&.content&.gsub!(
          /\[\[(#{note_potentially_linked_to.data["title"]})\]\]/i,
          anchor_tag
        )

        # Replace double-bracketed links using note filename
        # [[cats]]
        current_note.content.gsub!(
          /\[\[(#{title_from_filename})\]\]/i,
          anchor_tag
        )
        current_note.data["excerpt"]&.content&.gsub!(
          /\[\[(#{title_from_filename})\]\]/i,
          anchor_tag
        )

        # Replace double-bracketed links using note filename
        # [[cats]]
        current_note.content.gsub!(/\[\[(#{filename})\]\]/i, anchor_tag)
        current_note.data["excerpt"]&.content&.gsub!(
          /\[\[(#{filename})\]\]/i,
          anchor_tag
        )
      end

      # At this point, all remaining double-bracket-wrapped words are
      # pointing to non-existing pages, so let's turn them into disabled
      # links by greying them out and changing the cursor
      current_note.content =
        current_note
          .content
          .gsub(/\[\[([^\]]+)\]\]/i) do |match|
            link_text = $1.split("|").last # Take the part after the pipe
            <<~HTML.chomp
      <span title='There is no note that matches this link.' class='invalid-link'>
        #{link_text}
      </span>
    HTML
          end
    end

    # Identify note backlinks and add them to each note
    all_nodes.each do |current_note|
      # Nodes: Jekyll
      notes_linking_to_current_note =
        all_notes.filter { |e| e.content.include?(current_note.url) }

      # Nodes: Graph
      unless current_note.path.include?("_notes/index.html")
        graph_nodes << {
          id: note_id_from_note(current_note),
          path: "#{site.baseurl}#{current_note.url}#{link_extension}",
          label: current_note.data["title"]
        }
      end

      # Edges: Jekyll
      current_note.data["backlinks"] = notes_linking_to_current_note

      # Edges: Graph
      notes_linking_to_current_note.each do |n|
        graph_edges << {
          source: note_id_from_note(n),
          target: note_id_from_note(current_note)
        }
      end
    end

    File.write(
      "_includes/notes_graph.json",
      JSON.dump({ edges: graph_edges, nodes: graph_nodes })
    )
  end

  def note_id_from_note(note)
    note.data["title"].dup.gsub(/\W+/, " ").delete(" ").to_i(36).to_s
  end
end
