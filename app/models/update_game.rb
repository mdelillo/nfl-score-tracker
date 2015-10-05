class UpdateGame
  include Wisper::Publisher

  def initialize(game)
    @game = game
  end

  def call
    game_update = NflScoreTracker::GameCenterClient.get_game_update(game.game_center_id)
    return unless game_update

    update_game(game_update)
    new_score_events(game_update).each do |event|
      create_and_broadcast_score_event(event)
    end
  end

  private

  attr_reader :game

  def update_game(game_update)
    game.update(
      home_team: game_update['home']['abbr'],
      away_team: game_update['away']['abbr'],
      home_team_score: game_update['home']['score']['T'],
      away_team_score: game_update['away']['score']['T'],
      ended: ended(game_update)
    )
  end

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

  def new_score_events(game_update)
    new_score_events = []

    updated_score_events = game_update['scrsummary']
    current_event_count = game.score_events.count
    if updated_score_events.keys.count > current_event_count
      new_score_events = updated_score_events
                         .sort_by { |k, _v| k.to_i }
                         .drop(current_event_count)
                         .map { |k, v| v.merge('id' => k) }
    end

    new_score_events
  end

  def create_and_broadcast_score_event(event)
    score_event = ScoreEvent.create!(
      game: game,
      game_center_id: event['id'],
      team_name: event['team'],
      type: event['type'],
      description: event['desc']
    )
    broadcast(:new_score_event, score_event.id)
  end
end
