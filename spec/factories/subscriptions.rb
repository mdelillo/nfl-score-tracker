FactoryGirl.define do
  factory :subscription do
    type 'Subscriptions::Log'
    args '{}'
    game
  end
end
