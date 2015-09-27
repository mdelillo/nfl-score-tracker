class ScoreEvent < ActiveRecord::Base
  self.inheritance_column = nil

  belongs_to :game

  validates :game_center_id, :team_name, :type, :description,
            presence: true
end
