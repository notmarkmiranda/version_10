module StatisticsPartialHelper
  def seasons_show?
    controller_name == 'seasons' && action_name == 'show'
  end
end
