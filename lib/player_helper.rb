module PlayerHelper
  def add_finished_at
    player.finished_at = Time.now
  end

  def score_player?
    commit == 'Score Player'
  end
end
