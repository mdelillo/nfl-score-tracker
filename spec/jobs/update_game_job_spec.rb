require 'rails_helper'

describe UpdateGameJob do
  describe '#perform' do
    let(:update_game) { instance_double('UpdateGame', :update_game, call: nil, subscribe: nil) }
    let(:game) { FactoryGirl.create(:game) }

    before do
      allow(UpdateGame).to receive(:new).with(game).and_return(update_game)
    end

    it 'calls UpdateGame' do
      UpdateGameJob.perform_now(game)

      expect(update_game).to have_received(:call)
    end

    it 'adds any subscriptions for the game' do
      subscription = Subscriptions::Log.create!(game: game)
      Subscriptions::Log.create!(game: FactoryGirl.create(:game))

      UpdateGameJob.perform_now(game)

      expect(update_game).to have_received(:subscribe).with(subscription)
    end
  end
end
