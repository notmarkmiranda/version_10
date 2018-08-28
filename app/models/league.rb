class League < ApplicationRecord
  include StatisticsCompiler

  validates :user, presence: true
  validates :name, presence: true
  belongs_to :user
  has_many :seasons
  has_many :games, -> { order('games.date') }, through: :seasons
  has_many :players, through: :games

  delegate :count, to: :seasons, prefix: true
  delegate :count, to: :games, prefix: true
  delegate :count, to: :players, prefix: true

  def current_season
    seasons.find_by(active: true) || seasons.last
  end

  def current_season_number
    return nil if seasons.empty?
    (seasons.index(current_season) + 1).to_i
  end

  def leader_full_name
  end

  def most_second_place_finishes
    return [['No One'], 0]
  end

  def ordered_rankings_full_names
    league_standings
  end

  def season_number(season=nil)
    return nil if seasons.empty?
    (seasons.index(season || current_season) + 1).to_i
  end

  def league_standings
    players.rank_league_by_score(current_season)
  end

end
