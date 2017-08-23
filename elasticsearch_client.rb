class ElasticsearchClient
  def initialize
    @client = Elasticsearch::Client.new(
      hosts: "http://localhost:9200",
      request_timeout: 10,
      transport_options: { headers: { "Content-Type" => "application/json" } }
    )
  end

  def get(id:)
    payload = {
      query: {
        match: {
          _id: "/adult-dependants-grant"
        }
      }
    }

    @client.search(index: "mainstream,government,detailed", body: payload)
  end
end
