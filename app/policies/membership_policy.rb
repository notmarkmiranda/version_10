class MembershipPolicy < ApplicationPolicy
  include MembershipApproval
  attr_accessor :user, :membership

  def initialize(user, membership)
    @user       = user
    @membership = membership
  end

  def show?
    user_is_involved?
  end
end
