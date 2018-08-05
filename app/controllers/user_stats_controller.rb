class UserStatsController < ApplicationController
  def show
    @user = User.find(params[:user_id])
    if params[:season]
      @season = Season.find(params[:season])
      @players = @user.players.joins(:game)
        .where('games.season_id = ?', params[:season])
        .order('games.date DESC')
    else
      @season = nil
      @players = @user.players.joins(:game)
        .order('games.date DESC')
    end
  end
end
