class SitemapLoader
  def self.iterator(sitemap_index)
    Enumerator.new do |yielder|
      parent_doc = File.open(sitemap_index) { |f| Nokogiri::XML(f) }
      directory = File.dirname(sitemap_index)
      files = parent_doc.css("sitemap loc").map { |location| extract_filename(directory, location) }

      puts "Found #{files.count} files"
      puts files

      files.each do |file|
        doc = File.open(file) { |f| Nokogiri::XML(f) }
        locations = doc.css("url loc")

        locations.each do |loc|
          yielder << loc.text
        end
      end
    end
  end

  def self.extract_filename(directory, location)
    directory + "/" + location.text.match(/[^\/]*$/)[0]
  end
end
