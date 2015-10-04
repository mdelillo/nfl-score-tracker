class Subscription < ActiveRecord::Base
  include Grape::Entity::DSL

  belongs_to :game

  validates :game, :type, presence: true

  entity do
    expose :id, :type, :args, :game_id
  end
end
