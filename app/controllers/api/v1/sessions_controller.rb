class Api::V1::SessionsController < Api::ApiController

  def create
    user = User.find_by_email(auth_params[:email])
    if user.valid_password?(auth_params[:password])
      jwt = Auth.issue({ user: user.id })
      render json: { jwt: jwt }
    else
    end
  end

  private

  def auth_params
    params.require(:auth).permit(:email, :password)
  end
end
