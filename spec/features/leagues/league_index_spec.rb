require 'rails_helper'

describe 'Visitor can view league#index', type: :feature do
  describe 'as a visitor' do
    let!(:public_league) { create(:league, privated: false) }

    it 'should show the details for a public leagues and details for private leagues' do
      visit leagues_path

      within('.public-league') do
        expect(page).to have_content public_league.name
        expect(page).to have_content public_league.games_count
        expect(page).to have_content public_league.average_players_per_game
      end
    end
  end
end
