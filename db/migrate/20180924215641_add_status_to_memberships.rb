class AddStatusToMemberships < ActiveRecord::Migration[5.2]
  def change
    add_column :memberships, :status, :integer, default: 0
  end
end
