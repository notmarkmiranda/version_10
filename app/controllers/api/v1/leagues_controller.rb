class Api::V1::LeaguesController < Api::ApiController
  include ActionController::Serialization
  skip_before_action :authenticate_api!
  respond_to :json

  def show
    if authorize league
      render json: league, serializer: LeagueDetailsSerializer
    end
  end

  def public
    render json: League.non_private, status: 200
  end

  private

  def league
    @league ||= League.find(params[:id])
  end
end
