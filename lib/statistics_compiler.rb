module StatisticsCompiler
  def average_players_per_game
    return 0.0 if games_count.zero?
    (players_count.to_f / games_count * 100).floor / 100.0
  end
end
