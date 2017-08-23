require "elasticsearch"

client = Elasticsearch::Client.new(
  hosts: "http://localhost:9200",
  request_timeout: 10,
  transport_options: { headers: { "Content-Type" => "application/json" } }
)

response = client.get(type: '_all', id: "/guidance/open-policy-making-toolkit", index: "detailed")

puts response
