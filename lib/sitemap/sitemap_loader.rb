class SitemapLoader
  def self.iterator(sitemap_filename)
    Enumerator.new do |yielder|
      doc = File.open(sitemap_filename) { |f| Nokogiri::XML(f) }
      locations = doc.css("url loc")

      locations.each do |loc|
        yielder << loc.text
      end
    end
  end
end
