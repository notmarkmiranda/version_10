class RejectsController < ApplicationController
  def update
    authorize membership, policy_class: RejectsPolicy
    membership.reject!(current_user) if membership.can_be_rejected?
    redirect_to notifications_path
  end

  private

  def membership
    @membership ||= Membership.find(params[:membership_id])
  end
end
