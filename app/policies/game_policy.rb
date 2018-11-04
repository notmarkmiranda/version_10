class GamePolicy < ApplicationPolicy
  attr_reader :user, :game

  def initialize(user, game)
    @user = user
    @game = game
  end

  def new?
    user_is_admin?
  end

  private

  def league
    game&.league
  end

  def memberships
    @memberships ||= Membership.where(league: league, user: user)
  end

  def user_is_admin?
    memberships.where(role: 1).any?
  end
end
