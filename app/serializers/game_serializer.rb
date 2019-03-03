class GameSerializer < ActiveModel::Serializer
  attributes :id, :winner_full_name, :formatted_full_date, :players_count, :total_pot
end
