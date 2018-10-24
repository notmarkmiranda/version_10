class NotificationsController < ApplicationController
  def index
    authorize Notification
    @notifications = current_user.notifications.ordered
  end

  def show
    @notification = Notification.find(params[:id])
    @notification.mark_as_read! if @notification.can_be_read?
    authorize @notification
  end
end
