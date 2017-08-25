class CrawlerAnalyser
  def self.find_pages_missing_from_crawl(crawler_index)
    client = ElasticsearchClient.new
    pages_in_site_search = client.get_all("mainstream,government,detailed")

    missing_docs = Set.new
    found_docs = Set.new

    pages_in_site_search.each do |page|
      puts page
      # QQ Search sitemap index
    end
  end
end
