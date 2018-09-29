class RejectsPolicy < ApplicationPolicy
  attr_accessor :user, :membership

  def initialize(user, membership)
    @user       = user
    @membership = membership
  end

  def update?
    all_user_validations
  end

  private

  def all_user_validations
    user_is_involved? &&
      approver_and_requestor_are_not_both_admins? &&
      user_is_not_requestor?
  end

  def user_is_involved?
    !user.nil? && membership.users.include?(user)
  end

  def approver_and_requestor_are_not_both_admins?
    admins = membership.league.admins
    !(admins.include?(membership.requestor) && admins.include?(user))
  end

  def user_is_not_requestor?
    membership.requestor != user
  end
end
