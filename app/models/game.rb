class Game < ApplicationRecord
  validates :date, presence: true
  belongs_to :season
  has_many :players

  def formatted_date
    date.strftime('%B %Y')
  end
end
