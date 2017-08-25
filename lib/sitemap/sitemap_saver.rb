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
      path = extract_path(url)

      body = {
        path: path
      }
      begin
        client.index(
          index: full_name,
          type: "sitemap_url",
          id: path,
          body: body
        )
      rescue Elasticsearch::Transport::Transport::Errors::BadRequest => e
        puts "Warn: could not save URL #{path}. #{e.message}"
      end

      puts "Saved #{index} URLs" if index % 1000 == 0
    end
  end

private
  def self.extract_path(url)
    url.downcase
      .sub("https://www.gov.uk", "")
      .sub("http://www.gov.uk", "")
      .sub(/^\/\//, "/") # some paths have two leading slashes
      .sub(/\/$/, "") # strip trailing slash
      .sub(/\?.*$/, "") # strip query string
  end
end
