class Game < ApplicationRecord
  validates :date, presence: true
  belongs_to :season
  has_many :players

  delegate :count, to: :players, prefix: true

  def formatted_date
    date.strftime('%B %Y')
  end

  def formatted_full_date
    date.strftime('%B %-e, %Y')
  end

  def score_game
    return nil if players.empty?
    score_players = lambda { |player| player.score_player }
    players.each(&score_players)
  end
end
