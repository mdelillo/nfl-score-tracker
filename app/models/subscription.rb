class Subscription < ActiveRecord::Base
  belongs_to :game

  validates :type, presence: true
end
