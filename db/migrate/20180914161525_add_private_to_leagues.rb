class AddPrivateToLeagues < ActiveRecord::Migration[5.2]
  def change
    add_column :leagues, :privated, :boolean, default: true
  end
end
