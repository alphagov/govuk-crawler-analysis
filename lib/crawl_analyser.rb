require "thor"
require_relative "comparison/internal_index_analyser"

class CrawlAnalyser < Thor
  desc "missing_from_sitemap CRAWLER_SITEMAP", "Find files which were crawled but are not in the internal search index"
  def missing_from_sitemap(crawler_sitemap)
    InternalIndexAnalyser.find_pages_missing_from_sitemap
  end
end
