class UpdateGameJob < ActiveJob::Base
  queue_as :default

  def perform(game)
    game_update = NflScoreTracker::GameCenterClient.get_game_update(game.game_center_id)
    return unless game_update

    game.update(
      home_team: game_update['home']['abbr'],
      away_team: game_update['away']['abbr'],
      home_team_score: game_update['home']['score']['T'],
      away_team_score: game_update['away']['score']['T'],
      ended: ended(game_update)
    )
  end

  private

  def ended(game_update)
    drives = game_update['drives'].reject { |id| id == 'crntdrv' }

    game_ending_drives = drives.select do |_drive_id, drive|
      game_ending_plays = drive['plays'].select do |_play_id, play|
        play['desc'] == 'END GAME'
      end

      game_ending_plays.any?
    end

    game_ending_drives.any?
  end
end
