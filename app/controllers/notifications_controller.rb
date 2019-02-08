class NotificationsController < ApplicationController
  def index
    authorize Notification
    @notifications = current_user.notifications.ordered
  end

  def show
    @notification = Notification.find(params[:id]).decorate
    @notification.mark_as_read!
    authorize @notification
  end
end
