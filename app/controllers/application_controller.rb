class ApplicationController < ActionController::Base
  helper_method :current_user

  def after_sign_in_path_for(resource)
    session[:user_id] = resource.id
    dashboard_path
  end

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def require_user
    redirect_to root_path unless current_user
  end
end
