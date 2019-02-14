class GameUsersController < ApplicationController
  def create
    authorize game
    user_creator = UserCreator.new(user_params, game_id)
    user = user_creator.save
    if user
      redirect_to game_path game, user_id: user.id
    else
      redirect_to game
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name)
  end

  def game
    @game ||= Game.find(game_id)
  end

  def game_id
    Rails.application.routes.recognize_path(URI(request.referer).path)[:id].to_i
  end
end
