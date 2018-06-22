class Season < ApplicationRecord
  belongs_to :league
  has_many :games
  has_many :players, through: :games

  delegate :count, to: :games, prefix: true

  default_scope { order(id: :asc) }

  def leader
    player_rankings.first
  end

  def leader_full_name
    leader.user_full_name
  end

  private

  def player_rankings
    players.rank_by_score(self)
  end
end
