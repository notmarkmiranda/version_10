class AddApprovedToMemberhsip < ActiveRecord::Migration[5.2]
  def change
    add_column :memberships, :approved, :boolean, default: false
    add_column :memberships, :requestor_id, :integer
  end
end
