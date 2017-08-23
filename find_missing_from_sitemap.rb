require "elasticsearch"
require_relative "elasticsearch_client"

client = ElasticsearchClient.new
response = client.get(id: "/adult-dependants-grant")

puts response
