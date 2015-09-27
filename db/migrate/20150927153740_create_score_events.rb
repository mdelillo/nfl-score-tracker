class CreateScoreEvents < ActiveRecord::Migration
  def change
    create_table :score_events do |t|
      t.string :game_center_id
      t.string :team_name
      t.string :type
      t.string :description

      t.references :game, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
