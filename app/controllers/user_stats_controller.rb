class UserStatsController < ApplicationController
  def show
    @user = User.find(params[:user_id])
    if params[:season] && params[:season] != 'all'
      @season = Season.find(params[:season])
      @players = @user.players.joins(:game)
        .where('games.season_id = ?', params[:season])
        .order('games.date DESC')
        .decorate
    else
      @season = nil
      @players = @user.players.joins(:game)
        .order('games.date DESC')
        .decorate
    end
  end
end
