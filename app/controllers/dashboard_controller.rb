class DashboardController < ApplicationController
  before_action :require_user

  def show
    @owned_leagues = current_user.owned_leagues.decorate
    @participated_leagues = current_user.participated_leagues.decorate
  end
end
