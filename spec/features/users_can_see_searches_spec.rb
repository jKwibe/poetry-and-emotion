require 'rails_helper'

RSpec.describe 'Can search poems' do
  it 'can get top 10 poems' do
    # Read data from the json files in spec/data
    poetry_res = File.read('spec/data/poetry_response.json')
    tone_res = File.read('spec/data/tone_data.json')

    # Parse the data from the json files to form objects
    poem_data = JSON.parse(poetry_res, symbolize_names: true)
    tone_data = JSON.parse(tone_res, symbolize_names: true)

    # Stub the requests from the API's
    stub_request(:get, 'https://poetrydb.org/author/Emily').to_return(status: 200, body: poetry_res)
    poem_data.first(10).each do |poem|
      stub_request(:get, "https://api.us-south.tone-analyzer.watson.cloud.ibm.com/instances/b9999265-a46e-4e59-99ab-5287613969fb/v3/tone?version=2017-09-21&text=#{poem[:title]}").to_return(status: 200, body: tone_res)
    end

    visit root_path

    fill_in :author, with: 'Emily'
    click_button 'Get Poems'
    expect(current_path).to eq('/search')

    within 'section.poems' do
      expect(page).to have_selector('.poem', count: 10)
    end
    within first('.poem') do
      expect(page).to have_content(poem_data[0][:title])

      within '.tones' do
        expect(page).to have_selector('li', count: tone_data[:document_tone][:tones].size)
        expect(page).to have_content(tone_data[:document_tone][:tones].first[:tone_name])
        expect(page).to have_content(tone_data[:document_tone][:tones].last[:tone_name])
      end
    end
  end

  it 'can get top 10 poems' do
    # Read data from the json files in spec/data
    poetry_res = File.read('spec/data/poetry_response.json')
    tone_res = File.read('spec/data/tone_empty.json')

    # Parse the data from the json files to form objects
    poem_data = JSON.parse(poetry_res, symbolize_names: true)

    # Stub the requests from the API's
    stub_request(:get, 'https://poetrydb.org/author/Emily').to_return(status: 200, body: poetry_res)
    poem_data.first(10).each do |poem|
      stub_request(:get, "https://api.us-south.tone-analyzer.watson.cloud.ibm.com/instances/b9999265-a46e-4e59-99ab-5287613969fb/v3/tone?version=2017-09-21&text=#{poem[:title]}").to_return(status: 200, body: tone_res)
    end

    visit root_path

    fill_in :author, with: 'Emily'
    click_button 'Get Poems'
    expect(current_path).to eq('/search')

    within 'section.poems' do
      expect(page).to have_selector('.poem', count: 10)
    end
    within first('.poem') do
      expect(page).to have_content(poem_data[0][:title])

      within '.tones' do
        expect(page).to have_selector('li', count: 1)
        expect(page).to have_content('Neutral')
      end
    end
  end
end
