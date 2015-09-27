class AddDefaultToGamesEnded < ActiveRecord::Migration
  def up
    change_column :games, :ended, :boolean, default: false
  end

  def down
    change_column :games, :ended, :boolean, default: nil
  end
end
