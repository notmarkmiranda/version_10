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
    return 'No One' if no_one_qualifies?
    league_standings.first.user_full_name
  end

  def most_second_place_finishes
    # max_hash = players.where(finishing_place: 2)
      # .select(:user_id)
      # .group(:user_id)
      # .order('count_id DESC')
      # .count(:id)
    # max_qty  = max_hash.values.max
    # max_ids  = max_hash.select { |k, v| v == max_qty }.keys
    max_ids = []
    return [['Stat not yet available.'], 0] if max_ids.empty?
    # [max_ids.map { |id| User.find(id).full_name}.sort, max_qty]
  end

  def ordered_rankings_full_names
    return [] if no_one_qualifies?
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
