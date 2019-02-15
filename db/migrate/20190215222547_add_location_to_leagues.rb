class AddLocationToLeagues < ActiveRecord::Migration[5.2]
  def change
    add_column :leagues, :location, :string
  end
end
