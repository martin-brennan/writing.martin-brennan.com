# Credit for this plugin goes to https://github.com/maximevaillancourt/jekyll-last-modified-at,
# I merely brought it inline to fix some bugs, the git modified date was not working at all.

require 'posix/spawn'
require 'pry'

module Jekyll
  module LastModifiedAt    
    PATH_CACHE = {}
    REPO_CACHE = {}

    class Tag < Liquid::Tag
      def initialize(tag_name, format, tokens)
        super
        @format = format.empty? ? nil : format.strip
      end

      def render(context)
        site = context.registers[:site]
        format = @format || site.config.dig('last-modified-at', 'date-format')
        article_file = context.environments.first['page']['path']
        puts "SITE SOURCE #{site.source}"
        Jekyll::LastModifiedAt::Determinator.new(site.source, article_file, format)
                    .formatted_last_modified_date
      end
    end

    class Git
      attr_reader :site_source

      def initialize(site_source)
        @site_source = site_source
        @is_git_repo = nil
      end

      def top_level_directory
        return nil unless git_repo?

        @top_level_directory ||= begin
          Dir.chdir(@site_source) do
            @top_level_directory = Executor.sh('git', 'rev-parse', '--show-toplevel').split[0] + '/.git'
          end
                                 rescue StandardError
                                   ''
        end
      end

      def git_repo?
        return @is_git_repo unless @is_git_repo.nil?

        @is_git_repo = begin
          Dir.chdir(@site_source) do
            Executor.sh('git', 'rev-parse', '--is-inside-work-tree').split[0] == 'true'
          end
                       rescue StandardError
                         false
        end
      end
    end

    class Determinator
      attr_reader :site_source, :page_path
      attr_accessor :format

      def initialize(site_source, page_path, format = nil)
        @site_source = site_source
        @page_path   = page_path
        @format      = format || '%d-%b-%y'
      end

      def git
        return REPO_CACHE[site_source] unless REPO_CACHE[site_source].nil?

        REPO_CACHE[site_source] = Git.new(site_source)
        REPO_CACHE[site_source]
      end

      def formatted_last_modified_date
        return PATH_CACHE[page_path] unless PATH_CACHE[page_path].nil?

        last_modified = last_modified_at_time.strftime(@format)
        PATH_CACHE[page_path] = last_modified
        last_modified
      end

      def last_modified_at_time
        raise Errno::ENOENT, "#{absolute_path_to_article} does not exist!" unless File.exist? absolute_path_to_article

        Time.at(last_modified_at_unix.to_i)
      end

      def last_modified_at_unix
        if git.git_repo?
          last_commit_date = Executor.sh(
            'git',
            '--git-dir',
            git.top_level_directory,
            'log',
            '-n',
            '1',
            '--format="%ct"',
            '--',
            relative_path_from_git_dir
          )[/\d+/]
          # last_commit_date can be nil iff the file was not committed.
          last_commit_date.nil? || last_commit_date.empty? ? mtime(absolute_path_to_article) : last_commit_date
        else
          mtime(absolute_path_to_article)
        end
      end

      def to_s
        @to_s ||= formatted_last_modified_date
      end

      def to_liquid
        @to_liquid ||= last_modified_at_time
      end

      private

      def absolute_path_to_article
        @absolute_path_to_article ||= Jekyll.sanitized_path(site_source, @page_path)
      end

      def relative_path_from_git_dir
        return nil unless git.git_repo?

        @relative_path_from_git_dir ||= Pathname.new(absolute_path_to_article).relative_path_from(File.dirname(Pathname.new(git.top_level_directory))).to_s
      end

      def mtime(file)
        File.mtime(file).to_i.to_s
      end
    end
  end

  module Hook
    def self.add_determinator_proc
      proc { |item|
        format = item.site.config.dig('last-modified-at', 'date-format')
        puts "SITE SOURCE #{item.site.source}"
        item.data['last_modified_at'] = Jekyll::LastModifiedAt::Determinator.new(item.site.source, item.path,
                                                         format)
      }
    end

    Jekyll::Hooks.register :posts, :post_init, &Hook.add_determinator_proc
    Jekyll::Hooks.register :pages, :post_init, &Hook.add_determinator_proc
    Jekyll::Hooks.register :documents, :post_init, &Hook.add_determinator_proc
  end
  module Executor
    extend POSIX::Spawn

    def self.sh(*args)
      r, w = IO.pipe
      e, eo = IO.pipe
      pid = spawn(*args,
                  :out => w, r => :close,
                  :err => eo, e => :close)

      if pid.positive?
        w.close
        eo.close
        out = r.read
        err = e.read
        ::Process.waitpid(pid)
        "#{out} #{err}".strip if out
      end
    ensure
      [r, w, e, eo].each do |io|
        begin
                                 io.close
        rescue StandardError
          nil
                               end
      end
    end
  end
end

Liquid::Template.register_tag('last_modified_at', Jekyll::LastModifiedAt::Tag)