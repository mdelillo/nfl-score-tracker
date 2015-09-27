require 'rails_helper'

describe 'Games' do
  it 'returns a list of all games' do
    FactoryGirl.create(:game, game_center_id: 'game-1')
    FactoryGirl.create(:game, game_center_id: 'game-2')

    get '/api/v1/games'

    expect(response).to be_success
    game_center_ids = json_body.map { |game| game['game_center_id'] }
    expect(game_center_ids).to eq %w(game-1 game-2)
  end
end
