class ApprovesController < ApplicationController
  def update
    authorize membership, policy_class: ApprovesPolicy
    membership.approve!(current_user) if membership.can_be_approved?
  end

  private

  def membership
    @membership ||= Membership.find(params[:membership_id])
  end
end
