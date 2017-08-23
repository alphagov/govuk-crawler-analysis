require "elasticsearch"

client = Elasticsearch::Client.new(
  hosts: "http://localhost:9200",
  request_timeout: 10,
  transport_options: { headers: { "Content-Type" => "application/json" } }
)

payload = {
  query: {
    match: {
      _id: "/adult-dependants-grant"
    }
  }
}
response = client.search(index: "mainstream,government,detailed", body: payload)

puts response
