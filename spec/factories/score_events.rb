FactoryGirl.define do
  factory :score_event do
    sequence(:game_center_id)
    team_name 'HOM'
    type 'TD'
    description 'Player on HOM scored a touchdown'
  end
end
