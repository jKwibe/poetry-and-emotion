require 'rails_helper'

RSpec.describe PoemTone do
  before(:each) do
    @data = JSON.parse(File.read('spec/data/poetry_response.json'), symbolize_names: true)
    @poem = PoemTone.new(@data[0])
  end
  it 'should have attributes' do
    tone_res = File.read('spec/data/tone_data.json')
    stub_request(:get, "https://api.us-south.tone-analyzer.watson.cloud.ibm.com/instances/b9999265-a46e-4e59-99ab-5287613969fb/v3/tone?version=2017-09-21&text=#{@data[0][:title]}").to_return(status: 200, body: tone_res)


    expect(@poem).to be_instance_of PoemTone
    expect(@poem.title).to eq(@data[0][:title])
    expect(@poem.author).to eq(@data[0][:author])
    expect(@poem.tones).to eq(%w[Sadness Tentative Analytical])
  end

  it 'should return neutral if no tone is received' do
    tone_res = File.read('spec/data/tone_empty.json')
    stub_request(:get, "https://api.us-south.tone-analyzer.watson.cloud.ibm.com/instances/b9999265-a46e-4e59-99ab-5287613969fb/v3/tone?version=2017-09-21&text=#{@data[0][:title]}").to_return(status: 200, body: tone_res)

    expect(@poem.title).to eq(@data[0][:title])
    expect(@poem.author).to eq(@data[0][:author])
    expect(@poem.tones).to eq(%w[Neutral])
  end
end
