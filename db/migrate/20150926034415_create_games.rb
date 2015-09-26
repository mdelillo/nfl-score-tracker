class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :game_center_id
      t.boolean :ended
      t.string :home_team
      t.string :away_team
      t.integer :home_team_score
      t.integer :away_team_score

      t.timestamps null: false
    end
  end
end
