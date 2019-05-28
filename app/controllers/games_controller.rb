class GamesController < ApplicationController
  def new
    @league = League.find(params[:league_id])
    @game = @league.new_game
    authorize @game
  end

  def create
    @game = Game.new(game_params)
    authorize @game
    if @game.save
      redirect_to @game
    else
      flash[:alert] = @game.errors.full_messages.join(", ")
    end
  end

  def show
    @game = Game.find(params[:id]).decorate
    @players = @game.completed? ? @game.players.in_place : @game.players.in_finishing_order
  end

  def edit
    @game = Game.find(params[:id]).decorate
    authorize @game
  end

  def update
    @game = Game.find(params[:id]).decorate
    authorize @game
    @game.update(game_params)
    redirect_to @game
  end

  def complete
    @game = Game.find(params[:id])
    authorize @game
    @game.complete! if @game.can_be_completed?
    redirect_to game_path(@game)
  end

  def uncomplete
    @game = Game.find(params[:id])
    authorize @game
    @game.uncomplete! if @game.can_be_uncompleted?
    redirect_to game_path(@game)
  end

  private

  def game_params
    params.require(:game).permit(:season_id, :date, :buy_in)
  end
end
