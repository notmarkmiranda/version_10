class Api::V1::SessionsController < Api::ApiController
  skip_before_action :authenticate_api!

  def create
    user = User.find_by_email(auth_params[:email])
    if user.valid_password?(auth_params[:password])
      jwt = Auth.issue({ user: user.id })
      render json: { jwt: jwt }
    else
      render json: { errors: 'unauthorized' }, status: 401
    end
  end

  private

  def auth_params
    params.require(:auth).permit(:email, :password)
  end
end
