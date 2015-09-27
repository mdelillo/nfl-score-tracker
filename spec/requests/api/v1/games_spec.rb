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
    context 'with valid parameters' do
      it 'creates a new game' do
        post '/api/v1/games', format: :json, game_center_id: 'game-1'

        expect(response.status).to eq 201
        expect(json_body['game_center_id']).to eq 'game-1'
      end
    end

    context 'with invalid parameters' do
      it 'responds with 422' do
        post '/api/v1/games', format: :json

        expect(response.status).to eq 422
        expect(json_body['error']).to eq "Validation failed: Game Center ID can't be blank"
      end
    end
  end

  describe 'DELETE /api/v1/games/:id' do
    context 'when the game exists' do
      it 'deletes the game' do
        game = FactoryGirl.create(:game, game_center_id: 'game-1')

        delete "/api/v1/games/#{game.id}"

        expect(response.status).to eq 200
        expect(json_body['game_center_id']).to eq 'game-1'
      end
    end

    context 'when the game does not exist' do
      it 'responds with 404' do
        delete '/api/v1/games/non-existent'

        expect(response.status).to eq 404
        expect(json_body['error']).to eq "Couldn't find Game with 'id'=non-existent"
      end
    end
  end
end
