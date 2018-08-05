module StatisticsPartialHelper
  def seasons_show?
    controller_name == 'seasons' && action_name == 'show'
  end

  def decimal_to_percentage(number, precision:)
    number_to_percentage(number * 100.0, precision: precision)
  end
end
