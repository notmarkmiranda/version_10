class GamesController < ApplicationController
  def new
    @league = League.find(params[:league_id])
    @game = @league.new_game
    authorize @game
  end

  def create
    @game = Game.new(game_params)
    if @game.save
      redirect_to @game
    end
  end

  def show
    @game = Game.find(params[:id])
  end

  def complete
    @game = Game.find(params[:id])
    authorize @game
    @game.complete! if @game.can_be_completed?
    redirect_to game_path(@game)
  end

  private

  def game_params
    params.require(:game).permit(:season_id, :date, :buy_in)
  end
end
