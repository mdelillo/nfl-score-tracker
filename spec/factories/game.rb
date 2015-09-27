FactoryGirl.define do
  factory :game do
    game_center_id '2001010100'
    ended false
    home_team 'HOM'
    away_team 'AWY'
    home_team_score 0
    away_team_score 0
  end
end
