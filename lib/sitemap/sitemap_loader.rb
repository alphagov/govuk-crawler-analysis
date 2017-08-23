require_relative "../client/elasticsearch_client"
require "nokogiri"

class SitemapLoader
  def self.load_sitemap(sitemap_file, index_name)
    client = ElasticsearchClient.new

    # client.create_index(index_name)
    # puts "Created index '#{index_name}'!"

    doc = File.open(sitemap_file) { |f| Nokogiri::XML(f) }
    puts "Finding URLs in sitemap"
    pages = doc.css("url loc")
    puts "Found #{pages.count} pages in sitemap"

    pages.each do |page|
      puts page.text
    end

    require 'pry'; binding.pry
  end
end
