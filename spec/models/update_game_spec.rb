require 'rails_helper'

describe UpdateGame do
  let(:game) { FactoryGirl.create(:game) }
  let(:update_game) { UpdateGame.new(game) }

  describe '#call' do
    before do
      allow(NflScoreTracker::GameCenterClient)
        .to receive(:get_game_update)
        .with(game.game_center_id)
        .and_return(game_update)
    end

    context 'when there is an update' do
      let(:drives) { { 'crntdrv' => 0 } }
      let(:scrsummary) { {} }
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
          },
          'scrsummary' => scrsummary
        }
      end

      it 'updates the teams and scores' do
        update_game.call

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
          update_game.call

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
          update_game.call

          expect(game.ended?).to eq false
        end
      end

      context 'when there are new score events' do
        let(:scrsummary) do
          {
            '3' => {
              'team' => 'NYG',
              'type' => 'TD',
              'desc' => 'Touchdown Giants!'
            },
            '4' => {
              'team' => 'DAL',
              'type' => 'FG',
              'desc' => 'Dallas field goal'
            },
            '5' => {
              'team' => 'NYG',
              'type' => 'SAF',
              'desc' => 'Giants safety'
            }
          }
        end

        before do
          FactoryGirl.create(:score_event, game: game, team_name: 'NYG', type: 'TD', description: 'Touchdown Giants!')
        end

        it 'creates a ScoreEvent for each new event' do
          expect { update_game.call }.to change { ScoreEvent.count }.by(2)
          expect(ScoreEvent.find_by(game_center_id: '4').description).to eq 'Dallas field goal'
          expect(ScoreEvent.find_by(game_center_id: '5').description).to eq 'Giants safety'
        end

        it 'broadcasts an event for each new event' do
          allow(update_game).to receive(:broadcast)

          update_game.call

          expect(update_game).to have_received(:broadcast).with(:new_score_event, ScoreEvent.offset(1).last.id)
          expect(update_game).to have_received(:broadcast).with(:new_score_event, ScoreEvent.last.id)
        end
      end

      context 'when there are no new score events' do
        it 'does not create any ScoreEvents' do
          expect { update_game.call }.not_to change { ScoreEvent.count }
        end

        it 'does not broadcast an event' do
          allow(update_game).to receive(:broadcast)

          update_game.call

          expect(update_game).not_to have_received(:broadcast)
        end
      end
    end

    context 'when there is no update' do
      let(:game_update) { nil }

      it 'does nothing' do
        expect { update_game.call }
          .not_to change { game.updated_at }
      end
    end
  end
end
