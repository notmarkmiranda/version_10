class Player < ApplicationRecord
  belongs_to :game
  belongs_to :user

  delegate :full_name, to: :user, prefix: true
  delegate :buy_in, to: :game, prefix: true

  def calculate_score
    # place = finishing_place if place.nil?
    numerator = game_players_count * game_buy_in ** 2 / total_expense
    denominator = finishing_place + 1
    ((Math.sqrt(numerator) / denominator) * 100).floor / 100.0
  end

  def score_player
    update(score: calculate_score)
  end

  def self.rank_by_score(season)
    @active_season = season
    @season_users = select(:user_id).distinct.pluck(:user_id)
    return if @season_users.empty?

    find_by_sql(query)
  end

  private

  def game_players_count
    game.players_count
  end

  def self.query
    "SELECT user_id, SUM(score) AS cumulative_score, COUNT(game_id) \
     AS games_count FROM (#{subquery}) AS c_players GROUP BY \
     c_players.user_id ORDER BY cumulative_score DESC"
  end

  def self.subquery
    # TODO: (2018-04-26) markmiranda => LIMIT 9 needs to change to a season setting
    @season_users.map do |user_id|
      "(SELECT players.* FROM players INNER JOIN games ON \
       players.game_id = games.id WHERE user_id = #{user_id} AND \
       games.season_id = #{@active_season.id} ORDER BY score LIMIT 9)"
    end.join("\nUNION ALL\n")
  end

  def total_expense
    game_buy_in + additional_expense
  end
end
