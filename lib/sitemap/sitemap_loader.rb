require_relative "../client/elasticsearch_client"
require "nokogiri"
require "securerandom"

class SitemapLoader
  def self.load_sitemap(sitemap_file, index_name)
    client = ElasticsearchClient.new

    full_name = index_name + "_" + SecureRandom.uuid

    client.create_index(full_name)
    puts "Created index '#{full_name}'!"

    doc = File.open(sitemap_file) { |f| Nokogiri::XML(f) }
    puts "Finding URLs in sitemap"
    urls = doc.css("url loc")
    puts "Found #{pages.count} pages in sitemap"

    urls.each do |page|
      puts url.text
    end
  end
end
