class NotificationsController < ApplicationController
  def index
    authorize Notification
    @notifications = current_user.notifications.ordered
  end
end
