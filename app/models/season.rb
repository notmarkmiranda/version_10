class Season < ApplicationRecord
  belongs_to :league
  has_many :games
  has_many :players, through: :games

  delegate :count, to: :games, prefix: true
  delegate :count, to: :players, prefix: true

  default_scope { order(id: :asc) }

  def average_players_per_game
    players_count.to_f / games_count
  end

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

    [max_ids.map { |id| User.find(id).full_name }.sort, max_qty]
  end

  def standings
    players.rank_by_score(self)
  end

  def ordered_rankings_full_names
    return [] if no_one_qualifies?
    standings
  end

  private

  def no_one_qualifies?
    games_count.zero? || players_count.zero?
  end
end
