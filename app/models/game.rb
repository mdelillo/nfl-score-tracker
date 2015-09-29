class Game < ActiveRecord::Base
  include Grape::Entity::DSL

  has_many :score_events, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  validates :game_center_id, presence: true, uniqueness: true

  scope :in_progress, -> { where(ended: false) }

  def winner
    return unless ended?

    if home_team_score > away_team_score
      home_team
    elsif home_team_score < away_team_score
      away_team
    end
  end

  entity do
    expose :id, :game_center_id, :home_team, :away_team, :home_team_score, :away_team_score, :ended, :winner
  end
end
