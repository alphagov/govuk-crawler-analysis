require "elasticsearch"
require_relative "lib/elasticsearch_client"

input = [
  "/government/publications/designated-teacher-for-looked-after-children", # statutory_guidance
  "/government/publications/designated-teacher-for-looked-after-children?some-query", # duplicate
  "/if-your-child-is-taken-into-care", # guidance
  "/government/news/government-to-extend-green-flag-award-for-5-more-years", # press_release
  "/not/a/govuk/path",
  "/not/a/govuk/path?other-version",
]

client = ElasticsearchClient.new

missing_docs = Set.new
found_docs = Set.new

input.each do |path|
  cleaned_path = path.sub(/\?.*$/, "")
  if !(missing_docs.include?(cleaned_path) || found_docs.include?(cleaned_path))
    es_doc = client.get(id: cleaned_path)

    if es_doc.nil?
      missing_docs << cleaned_path
    else
      found_docs << cleaned_path
    end
  end
end

puts "#{missing_docs.count} missing documents"
puts missing_docs.to_a
