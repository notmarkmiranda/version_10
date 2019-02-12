class PlayerDecorator < ApplicationDecorator
  delegate_all

  def additional_expense_text(previous_text=false)
    text = "Rebuy or Add-on: #{h.number_to_currency(object.additional_expense, precision: 0)}"
    return "| #{text}" if previous_text && object.has_additional_expense?
    return text if object.has_additional_expense?
    nil
  end

  def delete_and_score_buttons
    return unless h.policy(game_object).user_is_admin?
    button_elements = []
    button_elements.push(score_button) if (object.finished_at.nil? && game_object.not_completed?)
    button_elements.push(delete_button) if game_object.not_completed?

    h.content_tag(:div, class: 'game-player-actions') do
      button_elements.join.html_safe
    end
  end

  def name_with_place
    if game_object.completed?
      "#{object.finishing_place}. #{object.user_full_name}"
    else
      object.user_full_name
    end
  end

  def place_and_score
    return unless object.finishing_place && object.score
    h.content_tag(:div, class: 'caption-text text-danger') do
      "#{object.finishing_place.ordinalize} place out of #{h.pluralize(object.game_players_count, 'player')} | Score: #{object.score}"
    end
  end

  def score_text
    additional_expense = object.has_additional_expense?
    if game_object.completed?
      "Score: #{object.score} #{additional_expense_text(true)}"
    elsif object.finished_at
      "Finished: #{object.finished_at.strftime('%b %-e, %l:%M %p')} #{additional_expense_text(true)}"
    elsif object.has_additional_expense?
      additional_expense_text
    end
  end

  private

  def game_object
    object.game
  end

  def score_button
    h.button_to 'Score Player', h.player_path(object, commit: 'Score Player'), method: :patch, class: 'btn btn-outline-info btn-sm mr-2'
  end

  def delete_button
    h.button_to 'Delete Player', h.player_path(object), method: :delete, class: 'btn btn-danger btn-sm'
  end
end
