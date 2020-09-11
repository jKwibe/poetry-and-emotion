class ToneService
  def tone_data(text)
    JSON.parse(get_tone(text).body, symbolize_names: true)
  end

  private

  def get_tone(text)
    conn.get('tone') do |p|
      p.params[:version] = '2017-09-21'
      p.params[:text] = text
    end
  end

  def conn
    url = 'https://api.us-south.tone-analyzer.watson.cloud.ibm.com/instances/b9999265-a46e-4e59-99ab-5287613969fb/v3/'
    Faraday.new(url: url) do |builder|
      builder.use Faraday::Request::BasicAuthentication, 'apikey', ENV['TONE_API']
    end
  end
end
