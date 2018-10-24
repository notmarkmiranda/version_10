class Membership < ApplicationRecord
  attr_accessor :skip_notification
  validates :user_id, presence: true, uniqueness: { scope: :league_id }
  validates :league_id, presence: true
  validates :role, numericality: { only_integer: true }

  belongs_to :user
  belongs_to :league
  belongs_to :requestor, class_name: 'User', optional: true
  belongs_to :decider, class_name: 'User', optional: true

  enum role: [:member, :admin]
  enum status: [:pending, :approved, :rejected]

  after_create :create_notifications, unless: :skip_notification

  def approve!(user)
    update(decider: user, status: 1)
  end

  def approved?
    decider.present?
  end

  def can_be_approved?
    decider.nil? && pending?
  end

  def can_be_rejected?
    decider.nil? && pending?
  end

  def reject!(user)
    update(decider: user, status: 2)
  end

  def users
    league_admins.push(user).uniq
  end

  private

  def recipients
    users.reject { |u| u == requestor }
  end

  def league_admins
    league.admins.to_a
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
