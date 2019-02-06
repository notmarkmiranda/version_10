class AddFinishedAtToPlayers < ActiveRecord::Migration[5.2]
  def change
    add_column :players, :finished_at, :datetime
  end
end
