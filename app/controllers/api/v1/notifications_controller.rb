# This controller was initially made for an internal api call, thats why there are 2 authenticate calls
class Api::V1::NotificationsController < Api::ApiController
  include ActionController::Serialization
  respond_to :json
  skip_before_action :authenticate_api!
  before_action :authenticate_user!

  def last_five
    render json: current_user.last_five_notifications, status: 200
  end

  def mark_as_read
    if params[:id]
      notification = current_user.notifications.find(params[:id])
      notification.mark_as_read!
      render json: notification, status: 200
    else
      current_user.notifications.where(read_at: nil).update_all(read_at: Time.now)
      render json: current_user.last_five_notifications
    end
  end

  private

  def authenticate_user!
    return render json: :unauthorized, status: 401 unless current_user
  end
end
