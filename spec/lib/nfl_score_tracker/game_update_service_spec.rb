require 'rails_helper'

describe NflScoreTracker::GameUpdateService do
  describe '.update_games' do
    it 'enqueues jobs to update all games in progress' do
      game = double(:game)
      allow(Game).to receive(:in_progress).and_return([game])

      allow(UpdateGameJob).to receive(:perform_later)

      described_class.update_games

      expect(UpdateGameJob).to have_received(:perform_later).with(game)
    end
  end
end
