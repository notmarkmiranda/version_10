class MembershipAndNotificationUpdater
  attr_reader :membership, :notification, :user

  def initialize(membership:, notification:, user:)
    @membership = membership
    @notification = notification
    @user = user
  end

  def update
    notification.mark_as_read! if notification&.can_be_read?
    membership.approve!(user) if membership&.can_be_approved?
  end
end
