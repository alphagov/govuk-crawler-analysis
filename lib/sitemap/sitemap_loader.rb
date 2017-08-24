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
    puts "Found #{urls.count} pages in sitemap"

    urls.each_with_index do |url, index|
      body = {
        url: url
      }
      client.create(
        index: full_name,
        type: "sitemap_url",
        id: url,
        body: body
      )

      puts "Saved #{index} URLs" if index % 1000 == 0
    end
  end
end
