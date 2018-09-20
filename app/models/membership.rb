class Membership < ApplicationRecord
  attr_accessor :skip_notification
  validates :user_id, presence: true, uniqueness: { scope: :league_id }
  validates :league_id, presence: true
  validates :role, numericality: { only_integer: true }

  belongs_to :user
  belongs_to :league
  belongs_to :requestor, class_name: 'User', optional: true

  enum role: [:member, :admin]

  after_create :create_notifications, unless: :skip_notification

  private

  def recipients
    league.admins.to_a.push(user).uniq.reject { |u| u == requestor }
  end

  def create_notifications
    recipients.each do |rec|
      Notification.create(recipient: rec,
                          actor: self.requestor,
                          action: 'membership.requested',
                          notifiable: self)
    end
  end
end
