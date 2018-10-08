class MembershipAndNotificationUpdater
  attr_reader :membership, :notification, :user

  def initialize(membership:, notification:, user:)
    @membership = membership
    @notification = notification
    @user = user
  end

  def update
    if notification.can_be_read? && membership.can_be_approved?
      notification.mark_as_read!
      membership.approve!(user)
      true
    end
    false
  end
end
