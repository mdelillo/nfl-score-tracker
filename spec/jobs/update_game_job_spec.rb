require 'rails_helper'

describe UpdateGameJob do
  describe '#perform' do
    it 'calls UpdateGame' do
      update_game = double(:update_game, call: nil)
      game = double(:game)
      allow(UpdateGame).to receive(:new).with(game).and_return(update_game)

      UpdateGameJob.perform_now(game)

      expect(update_game).to have_received(:call)
    end
  end
end
