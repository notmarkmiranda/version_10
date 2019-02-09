class PlayerCreator
  attr_reader :player, :commit

  def initialize(player_params, commit)
    @player = Player.new(player_params)
    @commit = commit
  end

  def save
    add_finished_at if score_player?
    return player if player.save
    false
  end

  private

  def add_finished_at
    player.finished_at = Time.now
  end

  def score_player?
    commit == 'Score Player'
  end
end
