class CreateSeasons < ActiveRecord::Migration[5.2]
  def change
    create_table :seasons do |t|
      t.references :league, foreign_key: true
      t.boolean :active, default: true
      t.boolean :completed, default: false

      t.timestamps null: false
    end
  end
end
