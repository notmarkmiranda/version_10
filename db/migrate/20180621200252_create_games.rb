class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.references :season, foreign_key: true
      t.datetime :date
      t.boolean :completed, default: false
      t.integer :buy_in

      t.timestamps null: false
    end
  end
end
