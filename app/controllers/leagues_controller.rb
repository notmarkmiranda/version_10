class LeaguesController < ApplicationController
  def show
    authorize league
    @current_season = league.current_season
  end

  def new
    authorize League
    @league = current_user.owned_leagues.new
  end

  def create
    authorize League
    @league = current_user.leagues.new(league_params)
    if @league.save
      flash[:notice] = "#{@league.name} created!"
      redirect_to @league
    else
      flash[:alert] = 'Something went wrong'
      render :new
    end
  end

  private

  def league_params
    params.require(:league).permit(:name, :privated)
  end

  def league
    @league ||= League.find(params[:id])
  end
end
