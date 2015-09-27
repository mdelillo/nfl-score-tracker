require 'rails_helper'

describe 'Games' do
  describe 'GET /api/v1/games' do
    it 'returns a list of all games' do
      FactoryGirl.create(:game, game_center_id: 'game-1')
      FactoryGirl.create(:game, game_center_id: 'game-2')

      get '/api/v1/games'

      expect(response.status).to eq 200
      game_center_ids = json_body.map { |game| game['game_center_id'] }
      expect(game_center_ids).to eq %w(game-1 game-2)
    end
  end

  describe 'POST /api/v1/games' do
    context 'using form-input params' do
      it 'creates a new game' do
        post '/api/v1/games', game_center_id: 'game-1'

        expect(response.status).to eq 201
        expect(json_body['game_center_id']).to eq 'game-1'
      end
    end

    context 'using JSON' do
      it 'creates a new game' do
        post '/api/v1/games', format: :json, game_center_id: 'game-1'

        expect(response.status).to eq 201
        expect(json_body['game_center_id']).to eq 'game-1'
      end
    end
  end
end
