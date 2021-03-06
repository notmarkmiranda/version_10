class PlayerCreator
  include PlayerHelper
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
end
