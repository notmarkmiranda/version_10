class Player < ApplicationRecord
  belongs_to :game
  belongs_to :user

  delegate :full_name, to: :user, prefix: true
end
