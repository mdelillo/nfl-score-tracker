class ScoreEvent < ActiveRecord::Base
  self.inheritance_column = nil

  belongs_to :game

  validates :team_name, :type, :description,
            presence: true

  validates :game_center_id,
            presence: true,
            uniqueness: { scope: :game_id }
end
