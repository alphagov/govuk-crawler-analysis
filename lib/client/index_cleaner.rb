class IndexCleaner
  def self.clean_indices(name)
    client = ElasticsearchClient.new

    all_indices = client.all_indices
    matching_indices = all_indices.select { |i| i.start_with? name }

    if matching_indices.empty?
      puts "No indexes to delete"
    else
      puts "Deleting matching indices: #{matching_indices}"

      client.delete_indices(matching_indices)
    end
  end
end
