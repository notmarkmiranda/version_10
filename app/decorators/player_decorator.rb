class PlayerDecorator < ApplicationDecorator
  delegate_all

  def additional_expense_text
    if object.has_additional_expense?
      "| Rebuy or Add-on: #{h.number_to_currency(object.additional_expense, precision: 0)}"
    end
  end

  def name_with_place
    if game_object.completed?
      "#{object.finishing_place}. #{object.user_full_name}"
    else
      object.user_full_name
    end
  end

  def score_text
    if game_object.completed?
      "Score: #{object.score} #{additional_expense_text}"
    elsif object.finished_at
      "Finished: #{object.finished_at.strftime('%b %-e, %l:%M %p')}"
    end
  end

  def game_object
    object.game
  end
end
