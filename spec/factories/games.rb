FactoryGirl.define do
  factory :game do
    game_center_id { SecureRandom.uuid }
    ended false
    home_team 'HOM'
    away_team 'AWY'
    home_team_score 0
    away_team_score 0
  end
end
