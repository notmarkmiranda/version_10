class Season < ApplicationRecord
  include StatisticsCompiler

  belongs_to :league
  has_many :games
  has_many :players, through: :games

  delegate :count, to: :games, prefix: true
  delegate :count, to: :players, prefix: true

  default_scope { order(id: :asc) }

  def leader
    standings.first
  end

  def leader_full_name
    return 'No One' if no_one_qualifies?
    leader.user_full_name
  end

  def most_second_place_finishes
    max_hash = players.where(finishing_place: 2)
      .select(:user_id)
      .group(:user_id)
      .order('count_id DESC')
      .count(:id)
    max_qty = max_hash.values.max
    max_ids = max_hash.select { |k, v| v == max_qty }.keys
    return ['No One', 0] if max_ids.empty?
    [max_ids.map { |id| User.find(id).full_name }.sort, max_qty]
  end

  def ordered_rankings_full_names
    return [] if no_one_qualifies?
    standings
  end

  def self.for_select(league)
    league.seasons.map { |season| ["Season ##{league.season_number(season)}", season.id] }
  end

  def self.for_select_except_current(league, season_id)
    league.seasons.where.not(id: season_id).map{ |season| ["Season ##{league.season_number(season)}", season.id] }
  end

  def self.for_user_select_except_current(league, season_id)
    for_select_except_current(league, season_id).push(["View All Seasons", "all"])
  end

  def standings
    players.rank_by_score(self)
  end

  def total_pot
    games.map do |game|
      (game.buy_in * game.players_count) + game.players.sum(:additional_expense)
    end.sum
  end

  private

  def no_one_qualifies?
    games_count.zero? || players_count.zero?
  end
end
