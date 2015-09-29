require 'rails_helper'

describe Game do
  describe 'associations' do
    it { is_expected.to have_many(:score_events).dependent(:destroy) }
    it { is_expected.to have_many(:subscriptions).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :game_center_id }
    it { is_expected.to validate_uniqueness_of :game_center_id }
  end

  describe 'scopes' do
    describe '.in_progress' do
      it 'returns game that have not ended' do
        FactoryGirl.create(:game, ended: true)
        in_progress_game = FactoryGirl.create(:game, ended: false)

        expect(Game.in_progress).to eq [in_progress_game]
      end
    end
  end

  describe '#winner' do
    let(:game) { FactoryGirl.create(:game, home_team: 'NYG', away_team: 'DAL') }

    context 'when the game has ended' do
      before do
        game.update(ended: true)
      end

      context 'when the home team has a higher score' do
        it 'returns the home team' do
          game.update(home_team_score: 21, away_team_score: 3)

          expect(game.winner).to eq 'NYG'
        end
      end

      context 'when the away team has a higher score' do
        it 'returns the away team' do
          game.update(home_team_score: 3, away_team_score: 7)

          expect(game.winner).to eq 'DAL'
        end
      end

      context 'when scores are tied' do
        it 'returns the away team' do
          game.update(home_team_score: 10, away_team_score: 10)

          expect(game.winner).to eq nil
        end
      end
    end

    context 'when the game has not ended' do
      it 'returns nil' do
        game.update(ended: false)

        expect(game.winner).to eq nil
      end
    end
  end

  describe Game::Entity do
    subject { Game::Entity.new(Game.new) }

    it 'exposes fields of the game' do
      expect(subject.exposures.keys).to match_array(%i(
        id
        game_center_id
        home_team
        away_team
        home_team_score
        away_team_score
        ended
        winner
      ))
    end
  end
end
