class Notification < ApplicationRecord
  belongs_to :recipient, class_name: 'User'
  belongs_to :actor, class_name: 'User'
  belongs_to :notifiable, polymorphic: true

  scope :unread, -> { where(read_at: nil) }
  scope :ordered, -> { order('read_at DESC').order('created_at DESC') }

  def can_be_read?
    read_at.nil?
  end

  def has_decision?
    case notifiable.class.name
    when "Membership"
      !notifiable.pending?
    else
      nil
    end
  end

  def mark_as_read!
    update(read_at: Time.now) if can_be_read?
  end

  def notification_text
    case notifiable.class.name
    when "Membership"
      membership_text
    else
      nil
    end
  end

  def mark_as_read!
    update(read_at: Time.now) if read_at.nil?
  end

  def read_at_class
    read_at.nil? ? 'notification-unread' : 'notification-read'
  end

  def user_is_allowed?(user)
    case notifiable.class.name
    when "Membership"
      notifiable.requestor != user
    else
      nil
    end
  end

  def users
    [recipient, actor].compact
  end

  private

  def league_admins
    @admins ||= notifiable.league.admins
  end

  def membership_text
    if admin_requested_and_recipient?
      "#{actor.full_name} is adding #{notifiable.user.full_name} to #{notifiable.league.name}"
    elsif admin_requested?
      "#{actor.full_name} would like to add you to #{notifiable.league.name}"
    else
      "#{actor.full_name} requested to join #{notifiable.league.name}"
    end
  end

  def admin_requested_and_recipient?
    league_admins.include?(recipient) &&
      league_admins.include?(notifiable.requestor)
  end

  def admin_requested?
    league_admins.include?(notifiable.requestor)
  end
end
