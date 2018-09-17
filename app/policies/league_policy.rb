class LeaguePolicy < ApplicationPolicy
  attr_reader :user, :league

  def initialize(user, league)
    @user   = user
    @league = league
  end

  def show?
    !league.privated? || user_is_allowed?
  end

  def new?
    create?
  end

  def create?
    user
  end

  private

  def memberships
    @memberships ||= Membership.where(league: league, user: user)
  end

  def user_is_allowed?
    memberships.any?
  end

  def user_is_admin?
    memberships.where(role: 1).any?
  end

  def user_is_member?
    memberships.where(role: 0).any?
  end
end
