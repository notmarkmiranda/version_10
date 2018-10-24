class NotificationPolicy < ApplicationPolicy
  attr_reader :user

  def initialize(user, notification)
    @user = user
    @notification = notification
  end

  def index?
    user.present?
  end

  def show?
    user_is_involved?
  end

  private

  def user_is_involved?
    !user.nil? && @notification.users.include?(user)
  end
end
