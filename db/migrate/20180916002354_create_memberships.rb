class CreateMemberships < ActiveRecord::Migration[5.2]
  def change
    create_table :memberships do |t|
      t.references :user, foreign_key: true
      t.references :league, foreign_key: true
      t.integer :role, default: 0
      t.timestamps null:false
    end
  end
end
