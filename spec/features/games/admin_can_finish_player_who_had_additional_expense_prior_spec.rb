require 'rails_helper'

describe 'Admin can finish a player who had an additional expense added prior' do
  let(:player) { create(:player) }
  let(:game) { player.game }
  let(:admin) { game.league.user }

  context 'as an admin' do
    before do
      player.update(additional_expense: 100)
      stub_current_user(admin)
    end

    it 'allows a player who already has an additional expense to be finished' do
      travel_to Time.zone.local(2015, 5, 9, 17, 30, 00) do
        visit game_path(game)

        within('a.list-group-item.list-group-item-action.stat-line') do
          click_button 'Score Player'
        end

        within('a.list-group-item.list-group-item-action.stat-line') do
          expect(page).to have_content('Finished: May 9, 5:30 PM | Rebuy or Add-on: $100')
          expect(page).not_to have_button('Score Player')
        end
      end
    end
  end
end
