class UserStatsController < ApplicationController
  def show
    @user = User.find(params[:user_id])
    if params[:season_id]
      @season = true
      @players = @user.players.joins(:game)
        .where('games.season_id = ?', params[:season_id])
        .order('games.date DESC')
    else
      @season = false
      @players = @user.players.joins(:game)
        .order('games.date DESC')
    end
  end
end
