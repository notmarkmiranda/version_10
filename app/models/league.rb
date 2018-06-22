class League < ApplicationRecord
  validates :user, presence: true
  validates :name, presence: true
  belongs_to :user
  has_many :seasons

  delegate :count, to: :seasons, prefix: true
end
