class LeaguePolicy < ApplicationPolicy
  attr_reader :user, :league

  def initialize(user, league)
    @user   = user
    @league = league
  end
end
