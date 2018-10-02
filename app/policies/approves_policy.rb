class ApprovesPolicy < ApplicationPolicy
  include MembershipApproval
  attr_accessor :user, :membership

  def initialize(user, membership)
    @user       = user
    @membership = membership
  end

  def update?
    all_user_validations
  end
end
