class League < ApplicationRecord
  validates :user, presence: true
  validates :name, presence: true
  belongs_to :user
end
