class PoemTone
  attr_reader :title, :author
  def initialize(poem)
    @title = poem[:title]
    @author = poem[:author]
  end

  def tones
    return %w[Neutral] if tone_data[:document_tone][:tones].empty?

    tone_data[:document_tone][:tones].map { |tone| tone[:tone_name] }
  end

  private

  def tone_data
    @tone_data ||= ToneService.new.tone_data(@title)
  end
end
