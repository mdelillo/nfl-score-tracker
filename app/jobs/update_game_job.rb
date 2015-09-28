class UpdateGameJob < ActiveJob::Base
  queue_as :default

  def perform(game)
    update_game = UpdateGame.new(game)
    Subscription.where(game: game).each do |subscription|
      update_game.subscribe(subscription)
    end
    update_game.call
  end
end
