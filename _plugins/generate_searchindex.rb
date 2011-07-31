# Jekyll searchindex generator
#
# Version: 0.1
#
# Copyright (c) 2011 John Leach, http://johnleach.co.uk

# Licensed under the MIT license
# (http://www.opensource.org/licenses/mit-license.php)
#
# A generator that creates a search index in json format for
# javascript-based searching of jekyll sites.
#
# To use it, simply drop this script into the _plugins directory of
# your Jekyll site.

require 'pathname'
require 'json/pure'

module Jekyll

  class Page
    def to_searchindex
      { :label => data['title'], :value => File.join(@dir, url) }
    end
  end

  class Post
    def to_searchindex
      { :label => data['title'], :value => File.join(@dir, url) }
    end
  end

  class SearchIndex < StaticFile
    def write(dest)
      dest_path = destination(dest)
      FileUtils.mkdir_p(File.dirname(dest_path))
      File.open(dest_path, "w") do |f|
        f.write(to_json)
      end
      true
    end

    def to_json
      entries = @site.pages.collect { |p| p.to_searchindex }
      entries += @site.site_payload['site']['posts'].collect { |p| p.to_searchindex }
      entries.to_json
    end

  end

  class SearchIndexGenerator < Generator
    safe true
    priority :low

    def generate(site)
      site.static_files << SearchIndex.new(site, site.dest, '/', 'searchindex.json')
    end
  end
end
