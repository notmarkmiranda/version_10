class GamePolicy < ApplicationPolicy
  attr_reader :user, :game

  def initialize(user, game)
    @user = user
    @game = game
  end

  def can_edit?
    user_is_admin? && game.not_completed?
  end
  
  def create?
    user_is_admin?
  end

  def complete?
    user_is_admin?
  end

  def new?
    user_is_admin?
  end

  def edit?
    user_is_admin?
  end

  def update?
    user_is_admin?
  end

  def uncomplete?
    user_is_admin?
  end

  def user_is_admin?
    memberships.where(role: 1, user: user).any?
  end

  private

  def league
    game&.league
  end

  def memberships
    @memberships ||= Membership.where(league: league, user: user)
  end
end
