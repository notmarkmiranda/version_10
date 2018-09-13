module StatisticsCompiler
  def average_players_per_game
    return 0.0 if games_count.zero?
    (players_count.to_f / games_count * 100).floor / 100.0
  end

  def average_pot_size
    total_pot = games.map do |game|
      (game.buy_in * game.players_count) + game.players.sum(:additional_expense)
    end.sum
    (total_pot / games_count * 100).floor / 100
  end

  def no_one_qualifies?
    games_count.zero? || players_count.zero?
  end
end
