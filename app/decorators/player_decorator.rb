class PlayerDecorator < ApplicationDecorator
  delegate_all

  def additional_expense_text
    if object.has_additional_expense?
      "| Rebuy or Add-on: #{h.number_to_currency(object.additional_expense, precision: 0)}"
    end
  end

  def score_text
    "Score: #{object.score} #{additional_expense_text}"
  end
end
