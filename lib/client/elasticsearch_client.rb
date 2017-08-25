class ElasticsearchClient
  extend Forwardable

  def_delegator :@client, :index

  def initialize
    @client = Elasticsearch::Client.new(
      hosts: "http://localhost:9200",
      request_timeout: 10,
      transport_options: { headers: { "Content-Type" => "application/json" } }
    )
  end

  def all_indices
    @client.cat.indices.map { |i| i["index"] }
  end

  def create_index(name)
    @client.indices.create(index: name)
  end

  def delete_indices(names)
    @client.indices.delete(index: names)
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
    puts "#{id} has #{total} hits. Expected 1 hit." if total > 1

    hits["hits"].first
  end

  def get_all(index)
    search_body = { query: { match_all: {} } }
    scroll_timeout = "1m"

    initial_scroll = @client.search(
      index: index,
      scroll: scroll_timeout,
      size: 50,
      body: search_body,
      search_type: "scan",
    )

    scroll_id = initial_scroll.fetch("_scroll_id")

    Enumerator.new do |yielder|
      loop do
        page = @client.scroll(scroll_id: scroll_id, scroll: scroll_timeout)
        scroll_id = page.fetch("_scroll_id")

        hits = page["hits"]["hits"]

        break if hits.count == 0

        hits.each do |hit|
          yielder << hit
        end
      end
    end
  end
end
