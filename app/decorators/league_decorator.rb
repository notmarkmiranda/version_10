class LeagueDecorator < ApplicationDecorator
  delegate_all

  def game_frequency_text
    if object.games_every_x_weeks.nil?
      'Not enough games to measure this yet.'
    else
      h.pluralize(h.number_with_precision(object.games_every_x_weeks, precision: 2), 'week')
    end
  end

  def location_text
    if object.location.present?
      h.content_tag :div, class: 'caption-text text-warning' do
        league.location
      end
    end
  end

  def public_league_stats
    "# of Games: #{object.games_count} | \
    Average Players per Game: #{object.average_players_per_game} | \
    Average Pot: #{h.number_to_currency(object.average_pot_size, precision: 0) }"
  end
end
