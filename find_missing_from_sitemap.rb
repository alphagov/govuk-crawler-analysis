require "elasticsearch"
require_relative "elasticsearch_client"

input = [
  "/government/publications/designated-teacher-for-looked-after-children", # statutory_guidance
  "/if-your-child-is-taken-into-care", # guidance
  "/government/news/government-to-extend-green-flag-award-for-5-more-years", # press_release
  "/not/a/govuk/path",
]

client = ElasticsearchClient.new

input.each do |path|
  es_doc = client.get(id: path)
  puts es_doc
end
