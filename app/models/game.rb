class Game < ApplicationRecord
  validates :date, presence: true
  belongs_to :season
end
