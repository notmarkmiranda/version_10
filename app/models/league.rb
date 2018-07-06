class League < ApplicationRecord
  validates :user, presence: true
  validates :name, presence: true
  belongs_to :user
  has_many :seasons
  has_many :games, through: :seasons
  has_many :players, through: :games

  delegate :count, to: :seasons, prefix: true
  delegate :count, to: :games, prefix: true
  delegate :count, to: :players, prefix: true

  def average_players_per_game
    players_count.to_f / games_count
  end

  def current_season
    seasons.find_by(active: true) || seasons.last
  end

  def current_season_number
    return nil if seasons.empty?
    (seasons.index(current_season) + 1).to_i
  end
end
