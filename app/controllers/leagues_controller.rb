class LeaguesController < ApplicationController
  def show
    authorize league
    @current_season = league.current_season
  end

  private

  def league
    @league ||= League.find(params[:id])
  end
end
