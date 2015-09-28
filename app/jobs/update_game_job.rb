class UpdateGameJob < ActiveJob::Base
  queue_as :default

  def perform(game)
    UpdateGame.new(game).call
  end
end
