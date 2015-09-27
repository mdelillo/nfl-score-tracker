require 'rails_helper'

describe ScoreEvent do
  describe 'associations' do
    it { is_expected.to belong_to :game }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :game_center_id }
    it { is_expected.to validate_presence_of :team_name }
    it { is_expected.to validate_presence_of :type }
    it { is_expected.to validate_presence_of :description }
    it { is_expected.to validate_uniqueness_of(:game_center_id).scoped_to(:game_id) }
  end
end
