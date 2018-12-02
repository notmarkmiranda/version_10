class Game < ApplicationRecord
  validates :date, presence: true
  belongs_to :season
  has_many :players

  delegate :count, to: :players, prefix: true
  delegate :league, to: :season
  scope :descending_by_date, -> { order('date') }

  def formatted_date
    date.strftime('%B %Y')
  end

  def formatted_full_date
    date.strftime('%B %-e, %Y')
  end

  def in_the_future?
    date.future? || !completed?
  end

  def player_in_place_full_name(place)
    players.find_by(finishing_place: place)&.user_full_name
  end

  def score_game
    return nil if players.empty?
    score_players = lambda { |player| player.score_player }
    players.each(&score_players)
  end

  def total_pot
    normal_pot = (buy_in * players_count)
    additional_pot = players.map(&:additional_expense).compact.sum
    normal_pot + additional_pot
  end

  def winner_full_name
    player_in_place_full_name(1)
  end

  def season_league_season_number
    league.season_number(season)
  end
end
