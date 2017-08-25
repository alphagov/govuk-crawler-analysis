require "csv"

class CrawlerAnalyser
  def self.find_pages_missing_from_crawl(crawler_index)
    client = ElasticsearchClient.new
    pages_in_site_search = client.get_all("mainstream,government,detailed")

    missing_docs = Set.new
    found_urls = Set.new

    pages_in_site_search.each_with_index do |page, index|
      sitemap_page = client.get(id: page["_id"], index: crawler_index)

      if sitemap_page.nil?
        missing_docs << page
      else
        found_urls << page["_id"]
      end

      puts "Searched #{index} pages. Found #{missing_docs.count} missing docs so far" if index % 5000 == 0
    end

    puts "Found #{missing_docs.count} missing docs"

    CSV.open("missing_from_crawl.csv", "w") do |csv|
      csv << ["base_path", "content_store_document_type", "elasticsearch_type", "publishing_app", "is_withdrawn"]

      missing_docs.each do |doc|
        csv << [
          doc["_id"],
          doc["_source"]["content_store_document_type"],
          doc["_type"],
          doc["_source"]["publishing_app"],
          doc["_source"]["is_withdrawn"] ? "true" : "false",
        ]
      end
    end

    puts "Saved output to 'missing_from_crawl.csv'"
  end
end
