require 'rails_helper'

describe UpdateGameJob do
  let(:game) { FactoryGirl.create(:game) }

  describe '#perform' do
    before do
      allow(NflScoreTracker::GameCenterClient)
        .to receive(:get_game_update)
        .with(game.game_center_id)
        .and_return(game_update)
    end

    context 'when there is an update' do
      let(:drives) { { 'crntdrv' => 0 } }
      let(:game_update) do
        {
          'away' => {
            'abbr' => 'DAL',
            'score' => {
              'T' => 3
            }
          },
          'drives' => drives,
          'home' => {
            'abbr' => 'NYG',
            'score' => {
              'T' => 14
            }
          }
        }
      end

      it 'updates the teams and scores' do
        described_class.perform_now(game)

        expect(game.home_team).to eq 'NYG'
        expect(game.away_team).to eq 'DAL'
        expect(game.home_team_score).to eq 14
        expect(game.away_team_score).to eq 3
      end

      context 'when a drive has a game-ending play' do
        let(:drives) do
          {
            '1' => {
              'plays' => {
                '2' => {
                  'desc' => 'END GAME'
                }
              }
            },
            'crntdrv' => 20
          }
        end

        it 'sets ending to true' do
          described_class.perform_now(game)

          expect(game.ended?).to eq true
        end
      end

      context 'when there is no game-ending play' do
        let(:drives) do
          {
            '1' => {
              'plays' => {
                '2' => {
                  'desc' => 'END QUARTER 1'
                }
              }
            },
            'crntdrv' => 20
          }
        end

        it 'sets ending to false' do
          described_class.perform_now(game)

          expect(game.ended?).to eq false
        end
      end
    end

    context 'when there is no update' do
      let(:game_update) { nil }

      it 'does nothing' do
        expect { described_class.perform_now(game) }
          .not_to change { game.updated_at }
      end
    end
  end
end
