class LeaguesController < ApplicationController
  def show
    @league = League.find(params[:id])
    @current_season = @league.current_season
  end
end
