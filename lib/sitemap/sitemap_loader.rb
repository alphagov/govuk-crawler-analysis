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
    locations = doc.css("url loc")
    puts "Found #{locations.count} pages in sitemap"

    locations.each_with_index do |location, index|
      url = location.text

      body = {
        url: url
      }
      client.index(
        index: full_name,
        type: "sitemap_url",
        id: url,
        body: body
      )

      puts "Saved #{index} URLs" if index % 1000 == 0
    end
  end
end
