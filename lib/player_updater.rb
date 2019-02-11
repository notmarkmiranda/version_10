class PlayerUpdater
  include PlayerHelper
  attr_reader :player, :commit

  def initialize(player, commit)
    @player = player
    @commit = commit
  end

  def update
    add_finished_at if score_player?
    return player if player.save
    false
  end
end
