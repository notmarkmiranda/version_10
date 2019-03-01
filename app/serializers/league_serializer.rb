require 'action_view'
require 'action_view/helpers'

class LeagueSerializer < ActiveModel::Serializer
  attributes :id, :name, :games_count, :average_players_per_game, :average_pot_size

  def average_players_per_game
    object.average_players_per_game
  end

  def average_pot_size
    object.average_pot_size
  end

  def games_count
    object.games_count
  end
end
