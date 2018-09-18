class Membership < ApplicationRecord
  validates :user_id, presence: true, uniqueness: { scope: :league_id }
  validates :league_id, presence: true
  validates :role, numericality: { only_integer: true }

  belongs_to :user
  belongs_to :league

  enum role: [:member, :admin]

  after_create :create_notifications

  private

  def recipients
    league.admins.to_a << user
  end

  def create_notifications
    recipients.each do |recipient|
      Notification.create(
        recipient: recipient,
        actor: self.user,
        action: 'posted',
        notifiable: self
      )
    end
  end
end
