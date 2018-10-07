class AddApproverToMembership < ActiveRecord::Migration[5.2]
  def change
    add_column :memberships, :decider_id, :integer
  end
end
