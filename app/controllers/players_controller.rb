class PlayersController < ApplicationController
  def create
    @game = Game.find(game_id)
    @player_creator = PlayerCreator.new(merged_player_params, params[:commit])
    if @player_creator.save
      redirect_to @game
    end
  end

  private

  def player_params
    params.require(:player).permit(:user_id)
  end

  def game_id
    Rails.application.routes.recognize_path(URI(request.referer).path)[:id].to_i
  end

  def merged_player_params
    player_params.merge(game_id: game_id)
  end
end
