class Game < ActiveRecord::Base
  has_many :score_events, dependent: :destroy

  validates :game_center_id, presence: true, uniqueness: true

  def winner
    return unless ended?

    if home_team_score > away_team_score
      home_team
    elsif home_team_score < away_team_score
      away_team
    end
  end
end
