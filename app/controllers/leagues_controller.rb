class LeaguesController < ApplicationController
  before_action :check_permission_for_private_league, only: [:show]

  def show
    @current_season = league.current_season
  end

  private

  def check_permission_for_private_league
    redirect_to root_path if league.privated? && nil_or_not_a_member?
  end

  def league
    @league ||= League.find(params[:id])
  end

  def nil_or_not_a_member?
    (current_user.nil? || current_user.not_part_of_league?(league))
  end
end
