class AddApproverToMembership < ActiveRecord::Migration[5.2]
  def change
    add_column :memberships, :approver_id, :integer
  end
end
