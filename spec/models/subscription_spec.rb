require 'rails_helper'

describe Subscription do
  describe 'associations' do
    it { is_expected.to belong_to :game }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:type) }
  end
end
