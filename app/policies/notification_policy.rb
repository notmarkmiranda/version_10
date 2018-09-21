class NotificationPolicy < ApplicationPolicy
  attr_reader :user

  def initialize(user, notification)
    @user = user
    @notification = notification
  end

  def index?
    user.present?
  end
end
