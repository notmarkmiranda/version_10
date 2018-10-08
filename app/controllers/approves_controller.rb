class ApprovesController < ApplicationController
  def update
    authorize membership, policy_class: ApprovesPolicy
    updater = MembershipAndNotificationUpdater.new(
      membership: membership,
      notification: notification,
      user: current_user
    )
    flash[:notice] = "Membership Approved!" if updater.update
    redirect_to notifications_path
  end

  private

  def membership
    @membership ||= Membership.find(params[:membership_id])
  end

  def notification
    @notification ||= Notification.find(params[:notification_id]) if params[:notification_id]
  end
end
