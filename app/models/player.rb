class Player < ApplicationRecord
  belongs_to :game
  belongs_to :user

  delegate :full_name, to: :user, prefix: true
  delegate :buy_in, to: :game, prefix: true
  delegate :formatted_full_date, to: :game, prefix: true
  delegate :players_count, to: :game, prefix: true
  delegate :season, to: :game
  delegate :league, to: :season
  delegate :season_number, to: :league, prefix: true

  scope :in_place, -> { order(finishing_place: :asc) }
  scope :in_finishing_order, -> { order(finished_at: :desc) }

  def calculate_score
    numerator = game_players_count * game_buy_in ** 2 / total_expense
    denominator = finishing_place + 1
    ((Math.sqrt(numerator) / denominator) * 1000).floor / 1000.0
  end

  def finish_player_and_calculate_score(place)
    update(finishing_place: place)
    update_score
  end

  def has_additional_expense?
    additional_expense && !additional_expense.zero?
  end

  def score_player
    update(score: calculate_score)
  end

  def season_number
    league_season_number(season)
  end

  def self.rank_by_score(season, multiplier=1)
    @active_season = season
    @active_season_games_count = [season.games_count, 9].min

    @season_users = pluck(:user_id).uniq
    @multiplier = multiplier
    return if @season_users.empty?

    find_by_sql(query)
  end

  def self.rank_league_by_score(current_season)
    @league = current_season.league
    # get the league from the season

    @league_users = @league.players.pluck(:user_id).uniq
    @games_count = @league.games_count

    return if @league_users.empty?
    find_by_sql(league_query)
    # filter down users to users that have played in the league

    # get scores for user in this league
    # if a user plays in multiple leagues,
    # we need to make sure its only for players in the current league
    # reaching into the database multiple times IS dirty and I don't want to do that.

    # what if we did it by season:
    # if the season is the current season passed in,
    # we would set the multiplier to 1, otherwise 0.5
  end

  private

  def self.league_query
    "SELECT user_id, SUM(score) AS cumulative_score, \
    SUM(score) / #{@games_count} AS counted_score, \
    COUNT(game_id) AS games_count FROM (#{league_sub_query}) AS c_players \
    GROUP BY c_players.user_id ORDER BY counted_score DESC"
  end

  def self.league_sub_query
    @league_users.map do |user_id|
      "(SELECT players.* FROM players INNER JOIN games ON \
      players.game_id = games.id WHERE user_id = #{user_id} AND \
      games.season_id IN (#{@league.seasons.pluck(:id).join(',')}) \
      ORDER BY score DESC LIMIT #{@games_count})"
    end.join("\nUNION ALL\n")
  end

  def self.query
    # TODO: (2018-04-26) markmiranda => LIMIT 9 needs to change to a season setting
    "SELECT user_id, (SUM(score) * #{@multiplier}) AS cumulative_score, \
     (SUM(score) * #{@multiplier} / #{@active_season_games_count}) AS counted_score, \
     COUNT(game_id) AS games_count FROM (#{subquery}) AS c_players GROUP BY \
     c_players.user_id ORDER BY counted_score DESC"
  end

  def self.subquery
    # TODO: (2018-04-26) markmiranda => LIMIT 9 needs to change to a season setting
    @season_users.map do |user_id|
      "(SELECT players.* FROM players INNER JOIN games ON \
       players.game_id = games.id WHERE user_id = #{user_id} AND \
       games.season_id = #{@active_season.id} \
       ORDER BY score DESC LIMIT #{@active_season_games_count})"
    end.join("\nUNION ALL\n")
  end

  def total_expense
    game_buy_in + additional_expense
  end

  def update_score
    update(score: calculate_score)
  end
end
