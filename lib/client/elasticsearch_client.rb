class ElasticsearchClient
  def initialize
    @client = Elasticsearch::Client.new(
      hosts: "http://localhost:9200",
      request_timeout: 10,
      transport_options: { headers: { "Content-Type" => "application/json" } }
    )
  end

  def create_index(name)
    @client.indices.create(index: name)
  end

  def get(id:)
    payload = {
      query: {
        match: {
          _id: id
        }
      }
    }

    response = @client.search(index: "mainstream,government,detailed", body: payload)

    hits = response["hits"]
    total = hits["total"]

    return nil if total == 0
    raise "#{id} has #{total} hits. Expected 1 hit." if total > 1

    hits["hits"].first
  end
end
