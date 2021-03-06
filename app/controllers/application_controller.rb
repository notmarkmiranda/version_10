class ApplicationController < ActionController::Base
  include Pundit
  helper_method :current_user, :navbar_props, :check_and_mark_notification_as_read

  def navbar_props
    {
      routes: {
        rootPath: root_path,
        leaguesPath: leagues_path,
        dashboardPath: dashboard_path,
        newLeaguePath: new_league_path,
        destroyUserSessionPath: destroy_user_session_path,
        lastFiveNotificationsPath: api_v1_last_five_notifications_path,
        notificationsPath: notifications_path,
        newUserSessionPath: new_user_session_path,
        newUserRegistrationPath: new_user_registration_path
      },
      userAttributes: {
        currentUserEmail: current_user&.email,
        unreadNotificationCount: current_user&.unread_notifications_count
      },
      isLoggedIn: current_user.present?
    }
  end

  def after_sign_in_path_for(resource)
    return admin_root_path if resource.is_a? AdminUser
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
    flash[:alert] = "Oops, something went wrong."
    return redirect_to dashboard_path if current_user
    redirect_to root_path
  end
end
