class SearchFacade
  def self.poems(author, poem_count = 10)
    poetry_data(author).first(poem_count).map do |poem|
      PoemTone.new(poem)
    end
  end

  def self.poetry_data(author)
    @poetry_data ||= PoetryService.new.parsed_data(author)
  end
end
