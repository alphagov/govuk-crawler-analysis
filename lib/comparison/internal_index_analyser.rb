require "elasticsearch"
require_relative "../client/elasticsearch_client"
require_relative "../sitemap/sitemap_loader"

class InternalIndexAnalyser
  def self.find_pages_missing_from_sitemap(crawler_sitemap)
    sitemap_pages = SitemapLoader.iterator(crawler_sitemap)

    client = ElasticsearchClient.new

    missing_docs = Set.new
    found_docs = Set.new

    sitemap_pages.each_with_index do |url, index|
      cleaned_path = clean_path(url)
      if !(missing_docs.include?(cleaned_path) || found_docs.include?(cleaned_path))
        es_doc = client.get(id: cleaned_path)

        if es_doc.nil?
          missing_docs << cleaned_path
        else
          found_docs << cleaned_path
        end
      end

      puts "Compared #{index} pages. #{missing_docs.count} missing so far." if index % 5000 == 0
    end

    puts "#{missing_docs.count} missing documents"
    puts "#{found_docs.count} found documents"
    puts "#{found_docs.count + missing_docs.count} total documents"

    File.open("missing_from_sitemap.out", "w") do |file|
      missing_docs.each do |doc|
        file.puts(doc)
      end
    end
  end

  def self.clean_path(url)
    url.downcase
      .sub("https://www.gov.uk", "")
      .sub("http://www.gov.uk", "")
      .sub(/^\/\//, "/") # some paths have two leading slashes
      .sub(/\/$/, "") # strip trailing slash
      .sub(/\?.*$/, "") # strip query string
  end
end
