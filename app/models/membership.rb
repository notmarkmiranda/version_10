class Membership < ApplicationRecord
  validates :user_id, presence: true, uniqueness: { scope: :league_id }
  validates :league_id, presence: true
  validates :role, numericality: { only_integer: true }

  belongs_to :user
  belongs_to :league

  enum role: [:member, :admin]
end
