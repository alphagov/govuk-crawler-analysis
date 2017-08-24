require_relative "../client/elasticsearch_client"
require_relative "sitemap_loader"
require "nokogiri"
require "securerandom"

class SitemapSaver
  def self.load_sitemap(sitemap_file, index_name)
    client = ElasticsearchClient.new

    full_name = index_name + "_" + SecureRandom.uuid

    client.create_index(full_name)
    puts "Created index '#{full_name}'!"

    sitemap = SitemapLoader.iterator(sitemap_file)

    sitemap.each_with_index do |url, index|
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
