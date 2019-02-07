class LeagueDecorator < ApplicationDecorator
  delegate_all

  def game_frequency_text
    if object.games_every_x_weeks.nil?
      'Not enough games to measure this yet.'
    else
      h.pluralize(h.number_with_precision(object.games_every_x_weeks, precision: 2), 'week')
    end
  end
end
