class Notification < ApplicationRecord
  belongs_to :recipient, class_name: 'User'
  belongs_to :actor, class_name: 'User'
  belongs_to :notifiable, polymorphic: true

  scope :unread, -> { where(read_at: nil) }

  def dropdown_text
    case notifiable.class.name
    when "Membership"
      membership_dropdown_text
    else
      nil
    end
  end

  private

  def league_admins
    @admins ||= notifiable.league.admins
  end

  def membership_dropdown_text
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
