class AddRequestorToMembership < ActiveRecord::Migration[5.2]
  def change
    add_column :memberships, :requestor_id, :integer
  end
end
