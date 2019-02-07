class GameDecorator < ApplicationDecorator
  delegate_all

  def complete_or_uncomplete_buttons
    if h.policy(object).user_is_admin?
      if object.completed?
        h.button_to 'Uncomplete Game', h.uncomplete_game_path(object), class: 'btn btn-outline-info btn-sm mb-2'
      else
        h.button_to 'Complete Game', h.complete_game_path(object), class: 'btn btn-outline-danger btn-sm mb-2', disabled: object.not_enough_players?
      end
    end
  end
end
