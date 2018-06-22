class CreatePlayers < ActiveRecord::Migration[5.2]
  def change
    create_table :players do |t|
      t.references :game, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :finishing_place
      t.float :score
      t.integer :additional_expense, default: 0

      t.timestamps null: false
    end
  end
end
