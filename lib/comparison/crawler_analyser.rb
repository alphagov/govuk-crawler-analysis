class CrawlerAnalyser
  def self.find_pages_missing_from_crawl(crawler_index)
    client = ElasticsearchClient.new
    pages_in_site_search = client.get_all("mainstream,government,detailed")

    missing_docs = Set.new
    found_urls = Set.new

    pages_in_site_search.take(500).each_with_index do |page, index|
      sitemap_page = client.get(id: page["_id"], index: crawler_index)

      if sitemap_page.nil?
        missing_docs << page
      else
        found_urls << page["_id"]
      end

      puts "Searched #{index} pages. Found #{missing_docs.count} missing docs so far" if index % 5000 == 0
    end

    puts "Found #{missing_docs.count} missing docs"
  end
end
