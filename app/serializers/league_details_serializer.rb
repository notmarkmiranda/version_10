class LeagueDetailsSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :games,
             :location,
             :privated_text,
             :seasons_count,
             :average_players_per_game,
             :leader_full_name,
             :most_second_place_finishes,
             :ordered_rankings_full_names
  has_many :seasons
  has_many :games
end
