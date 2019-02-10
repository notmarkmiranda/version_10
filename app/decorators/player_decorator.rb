class PlayerDecorator < ApplicationDecorator
  delegate_all

  def additional_expense_text(previous_text=false)
    text = "Rebuy or Add-on: #{h.number_to_currency(object.additional_expense, precision: 0)}"
    return "| #{text}" if previous_text && object.has_additional_expense?
    return text if object.has_additional_expense?
    nil
  end

  def name_with_place
    if game_object.completed?
      "#{object.finishing_place}. #{object.user_full_name}"
    else
      object.user_full_name
    end
  end

  def score_text
    additional_expense = object.has_additional_expense?
    if game_object.completed?
      "Score: #{object.score} #{additional_expense_text(true)}"
    elsif object.finished_at && additional_expense
      "Finished: #{object.finished_at.strftime('%b %-e, %l:%M %p')} #{additional_expense_text(true)}"
    elsif object.has_additional_expense?
      additional_expense_text
    end
  end

  def game_object
    object.game
  end
end
