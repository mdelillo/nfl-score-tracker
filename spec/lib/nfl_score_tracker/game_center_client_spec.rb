require 'rails_helper'

describe NflScoreTracker::GameCenterClient do
  describe '.get_game_update' do
    context 'when request is successful' do
      it 'returns the response as a hash' do
        game_update = {
          'game-1' => {
            'home' => {
              'abbr' => 'NYG'
            }
          }
        }
        stub_request(:get, 'http://www.nfl.com/liveupdate/game-center/game-1/game-1_gtd.json')
          .to_return(status: 200, body: game_update.to_json)

        expect(described_class.get_game_update('game-1')).to eq(game_update['game-1'])
      end
    end

    context 'when request is unsuccessful' do
      it 'returns nil' do
        stub_request(:get, 'http://www.nfl.com/liveupdate/game-center/game-1/game-1_gtd.json')
          .to_return(status: 404, body: 'Not Found')
        expect(described_class.get_game_update('game-1')).to eq nil
      end
    end
  end
end
