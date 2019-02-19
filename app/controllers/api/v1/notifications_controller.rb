class Api::V1::NotificationsController < Api::ApiController
  include ActionController::Serialization
  respond_to :json
  before_action :authenticate_user!

  def last_five
    render json: current_user.last_five_notifications, status: 200
  end

  def mark_as_read
    if params[:id]
      notification = current_user.notifications.find(params[:id])
      notification.mark_as_read!
    else
      current_user.notifications.update_all(read_at: Time.now)
    end
  end

  private

  def authenticate_user!
    return render json: :unauthorized, status: 401 unless current_user
  end
end
