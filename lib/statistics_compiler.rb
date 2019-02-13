module StatisticsCompiler
  def average_players_per_game
    return 0.0 if no_one_qualifies?
    (players_count.to_f / games_count * 100).floor / 100.0
  end

  def average_pot_size
    return 0.0 if no_one_qualifies?
    total_pot = games.map do |game|
      (game.buy_in * game.players_count) + game.players.sum(:additional_expense)
    end.sum
    (total_pot / games_count * 100).floor / 100
  end

  def games_count
    games.where(completed: true).count
  end

  def no_games?
    games_count.zero?
  end

  def no_players?
    players_count.zero?
  end

  def no_one_qualifies?
    no_games? || no_players?
  end
end
