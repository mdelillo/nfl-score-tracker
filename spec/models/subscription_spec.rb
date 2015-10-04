require 'rails_helper'

describe Subscription do
  describe 'associations' do
    it { is_expected.to belong_to :game }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:game) }
    it { is_expected.to validate_presence_of(:type) }
  end

  describe Subscription::Entity do
    subject { Subscription::Entity.new(Subscription.new) }

    it 'exposes fields of the subscription' do
      expect(subject.exposures.keys).to match_array(%i(
        id
        type
        args
        game_id
      ))
    end
  end
end
