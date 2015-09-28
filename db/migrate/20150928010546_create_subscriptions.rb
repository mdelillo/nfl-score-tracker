class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.string :type
      t.json :args, default: '{}'
      t.references :game, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
