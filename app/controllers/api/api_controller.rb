class Api::ApiController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :authenticate_api!

  def api_current_user
    if auth_present?
      user = User.find(auth['user'])
      if user
        @api_current_user ||= user
      end
    end
  end

  def authenticate_api!
    render json: { errors: 'unauthorized' }, status: 401 unless logged_in?
  end

  def logged_in?
    !!api_current_user
  end

  private

  def token
    request.env['HTTP_AUTHORIZATION'].scan(/Bearer(.*)$/).flatten.last
  end

  def auth
    Auth.decode(token)
  end

  def auth_present?
    !!request.env.fetch('HTTP_AUTHORIZATION', '').scan(/Bearer/).flatten.first
  end
end
