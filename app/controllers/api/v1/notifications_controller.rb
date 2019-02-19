class Api::V1::NotificationsController < Api::ApiController
  include ActionController::Serialization
  respond_to :json

  def last_five
    return render json: :unauthorized, status: 401 unless current_user
    render json: current_user.last_five_notifications, status: 200
  end
end
