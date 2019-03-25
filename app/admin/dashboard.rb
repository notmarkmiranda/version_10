ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    div class: "blank_slate_container", id: "dashboard_default_message" do
      columns do
        column do
          panel 'Recent Leagues' do
            ul do
              League.all.each do |league|
                li link_to(league.name, admin_league_path(league))
              end
            end
          end
        end
        column do
          panel 'Recent Games' do
            ul do
              Game.order(date: :desc).each do |game|
                li link_to(game.formatted_full_date, admin_league_path(game))
              end
            end
          end
        end
      end
      span class: "blank_slate" do
        span I18n.t("active_admin.dashboard_welcome.welcome")
        small I18n.t("active_admin.dashboard_welcome.call_to_action")
      end
    end
  end
end
