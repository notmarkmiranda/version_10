class Api::V1::LeaguesController < Api::ApiController
  include ActionController::Serialization
  skip_before_action :verify_authenticity_token, only: [:public]
  respond_to :json

  def public
    render json: League.non_private, status: 200
  end
end
