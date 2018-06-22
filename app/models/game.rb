class Game < ApplicationRecord
  validates :date, presence: true
  belongs_to :season
  has_many :players

  delegate :count, to: :players, prefix: true

  def formatted_date
    date.strftime('%B %Y')
  end

  def score_game
    players.each { |pl| pl.score_player }
  end
end
