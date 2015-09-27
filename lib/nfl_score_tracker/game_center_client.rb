module NflScoreTracker
  class GameCenterClient
    def self.get_game_update(game_center_id)
      url = "http://www.nfl.com/liveupdate/game-center/#{game_center_id}/#{game_center_id}_gtd.json"
      response = Net::HTTP.get_response(URI(url))
      JSON.parse(response.body)[game_center_id] if response.code == '200'
    end
  end
end
