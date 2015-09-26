require 'rails_helper'

describe 'Games' do
  it 'returns an empty list' do
    get '/api/v1/games'

    expect(response).to be_success
    expect(JSON.parse(response.body)).to eq []
  end
end
