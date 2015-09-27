module NflScoreTracker
  class GameUpdateService
    def self.update_games
      Game.in_progress.each do |game|
        UpdateGameJob.perform_later(game)
      end
    end
  end
end
