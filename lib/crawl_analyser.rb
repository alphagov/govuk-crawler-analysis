require "thor"
require_relative "client/index_cleaner"
require_relative "comparison/crawler_analyser"
require_relative "comparison/internal_index_analyser"
require_relative "sitemap/sitemap_saver"

class CrawlAnalyser < Thor
  desc "missing_from_sitemap CRAWLER_SITEMAP", "Find pages which were crawled but are not in the internal search index"
  def missing_from_sitemap(crawler_sitemap)
    InternalIndexAnalyser.find_pages_missing_from_sitemap(crawler_sitemap)
  end

  desc "missing_from_crawl CRAWLER_INDEX", "Find pages in the internal search index but which were not found by the crawler"
  def missing_from_crawl(crawler_index)
    CrawlerAnalyser.find_pages_missing_from_crawl(crawler_index)
  end

  desc "load_sitemap SITEMAP_FILE INDEX_NAME", "Load sitemap file into an Elasticsearch index"
  def load_sitemap(sitemap_file, index_name)
    SitemapSaver.load_sitemap(sitemap_file, index_name)
  end

  desc "clean_indices INDEX_NAME", "Delete all indices with the given base name"
  def clean_indices(index_name)
    IndexCleaner.clean_indices(index_name)
  end
end
