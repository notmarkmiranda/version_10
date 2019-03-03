class SeasonSerializer < ActiveModel::Serializer
  attributes :id, :league_id, :active, :completed
end
