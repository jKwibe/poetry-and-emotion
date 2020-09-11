class PoetryService
  def parsed_data(author)
    JSON.parse(get_data(author).body, symbolize_names: true)
  end

  private

  def get_data(author)
    conn.get("author/#{author}")
  end

  def conn
    Faraday.new('https://poetrydb.org/')
  end
end
