require "thor"
require_relative "comparison/internal_index_analyser"
require_relative "sitemap/sitemap_loader"

class CrawlAnalyser < Thor
  desc "missing_from_sitemap CRAWLER_SITEMAP", "Find files which were crawled but are not in the internal search index"
  def missing_from_sitemap(crawler_sitemap)
    InternalIndexAnalyser.find_pages_missing_from_sitemap
  end

  desc "load_sitemap SITEMAP_FILE INDEX_NAME", "Load sitemap file into an Elasticsearch index"
  def load_sitemap(sitemap_file, index_name)
    SitemapLoader.load_sitemap(sitemap_file, index_name)
  end
end
