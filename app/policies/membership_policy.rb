class MembershipPolicy < ApplicationPolicy
  attr_accessor :user, :membership

  def initialize(user, membership)
    @user       = user
    @membership = membership
  end

  def show?
    user_is_involved?
  end

  private

  def user_is_involved?
    !user.nil? && membership.users.include?(user)
  end
end
