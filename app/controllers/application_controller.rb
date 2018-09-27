class ApplicationController < ActionController::Base
  include Pundit
  helper_method :current_user, :check_and_mark_notification_as_read

  def after_sign_in_path_for(resource)
    session[:user_id] = resource.id
    dashboard_path
  end

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def check_and_mark_notification_as_read
    @notification = Notification.find(params[:notification_id].to_i) if params[:notification_id]
    return user_not_authorized unless @notification.present?
    @notification&.mark_as_read!
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def require_user
    redirect_to root_path unless current_user
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    return redirect_to dashboard_path if current_user
    redirect_to root_path
  end
end
