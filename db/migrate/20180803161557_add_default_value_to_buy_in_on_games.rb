class AddDefaultValueToBuyInOnGames < ActiveRecord::Migration[5.2]
  def up
    change_column :games, :buy_in, :integer, default: 0
  end

  def down
    change_column :games, :buy_in, :integer, default: nil
  end
end
