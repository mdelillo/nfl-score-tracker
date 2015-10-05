require 'rails_helper'

describe 'Creating and following game' do
  it 'updates in-progress games and sends notifications for score events' do
    Given 'I am able to create and follow games'

    When 'I create a new game'
    Then 'The game has no teams or score'
    And 'The game is marked as not ended'
    And 'The game has no winner'

    When 'All games are updated before the game is available'
    Then 'The game is not updated'

    When 'All games are updated when the game is availble but has not started'
    Then 'The game is populated with teams and score'
    And 'The game is marked as not ended'
    And 'The game has no winner'

    When 'All games are updated in the middle of the game'
    Then 'The game score is updated'
    And 'The game is marked as not ended'
    And 'The game has no winner'

    When 'A subscription is created for the game'
    Then 'Notifications are not sent for previous score events'

    When 'All games are updated after the game ends'
    Then 'Notifications are sent for new score events'
    And 'The game score is updated again'
    And 'The game is marked as ended'
    And 'The game has a winner'

    When 'All games are updated after the game ends'
    Then 'The game is no longer updated'
  end

  def i_am_able_to_create_and_follow_games
  end

  def i_create_a_new_game
    post '/api/v1/games', format: :json, game_center_id: '2015092400'
    @game_id = json_body['id']
  end

  def the_game_has_no_teams_or_score
    get "/api/v1/games/#{@game_id}"
    expect(json_body).to include(
      'home_team' => nil,
      'away_team' => nil,
      'home_team_score' => nil,
      'away_team_score' => nil
    )
  end

  def the_game_is_marked_as_not_ended
    get "/api/v1/games/#{@game_id}"
    expect(json_body['ended']).to eq false
  end

  def the_game_has_no_winner
    get "/api/v1/games/#{@game_id}"
    expect(json_body['winner']).to eq nil
  end

  def all_games_are_updated_before_the_game_is_available
    stub_request(:get, 'http://www.nfl.com/liveupdate/game-center/2015092400/2015092400_gtd.json')
      .to_return(status: 404, body: 'Not Found')

    perform_enqueued_jobs do
      NflScoreTracker::GameUpdateService.update_games
    end
  end

  def the_game_is_not_updated
    get "/api/v1/games/#{@game_id}"
    expect(json_body).to include(
      'home_team' => nil,
      'away_team' => nil,
      'home_team_score' => nil,
      'away_team_score' => nil,
      'ended' => false,
      'winner' => nil
    )
  end

  def all_games_are_updated_when_the_game_is_availble_but_has_not_started
    stub_request(:get, 'http://www.nfl.com/liveupdate/game-center/2015092400/2015092400_gtd.json')
      .to_return(body: read_fixture('game-center/before.json'))

    perform_enqueued_jobs do
      NflScoreTracker::GameUpdateService.update_games
    end
  end

  def the_game_is_populated_with_teams_and_score
    get "/api/v1/games/#{@game_id}"
    expect(json_body).to include(
      'home_team' => 'NYG',
      'away_team' => 'WAS',
      'home_team_score' => 0,
      'away_team_score' => 0
    )
  end

  def all_games_are_updated_in_the_middle_of_the_game
    stub_request(:get, 'http://www.nfl.com/liveupdate/game-center/2015092400/2015092400_gtd.json')
      .to_return(body: read_fixture('game-center/middle.json'))

    perform_enqueued_jobs do
      NflScoreTracker::GameUpdateService.update_games
    end
  end

  def the_game_score_is_updated
    get "/api/v1/games/#{@game_id}"
    expect(json_body).to include(
      'home_team_score' => 25,
      'away_team_score' => 6
    )
  end

  def a_subscription_is_created_for_the_game
    post '/api/v1/subscriptions', format: :json, game_id: @game_id, type: 'Subscriptions::Pushbullet'
  end

  def notifications_are_not_sent_for_previous_score_events
    expect(a_request(:post, 'http://pushbullet.com/api-endpoint')).not_to have_been_made
  end

  def all_games_are_updated_after_the_game_ends
    WebMock.reset!
    stub_request(:get, 'http://www.nfl.com/liveupdate/game-center/2015092400/2015092400_gtd.json')
      .to_return(body: read_fixture('game-center/final.json'))
    stub_request(:post, 'http://pushbullet.com/api-endpoint')

    perform_enqueued_jobs do
      NflScoreTracker::GameUpdateService.update_games
    end
  end

  def notifications_are_sent_for_new_score_events
    expect(a_request(:post, 'http://pushbullet.com/api-endpoint')).to have_been_made.times(3)
  end

  def the_game_score_is_updated_again
    get "/api/v1/games/#{@game_id}"
    expect(json_body).to include(
      'home_team_score' => 32,
      'away_team_score' => 21
    )
  end

  def the_game_is_marked_as_ended
    get "/api/v1/games/#{@game_id}"
    expect(json_body['ended']).to eq true
  end

  def the_game_has_a_winner
    get "/api/v1/games/#{@game_id}"
    expect(json_body['winner']).to eq 'NYG'
  end

  def the_game_is_no_longer_updated
    expect(a_request(:get, 'http://www.nfl.com/liveupdate/game-center/2015092400/2015092400_gtd.json'))
      .not_to have_been_made
  end
end
