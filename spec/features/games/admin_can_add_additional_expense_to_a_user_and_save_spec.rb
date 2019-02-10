require 'rails_helper'

describe 'As an admin' do
  let(:game) { create(:game) }
  let(:admin) { game.league.user }

  before do
    stub_current_user(admin)
  end

  context 'when they visit the game_path' do
    context 'they are able to select a player from the dropdown and give them an additional expense' do
      it 'adds the additional expense to the player' do
        visit game_path(game)

        find('#player_user_id').find(:xpath, 'option[2]').select_option
        fill_in 'Rebuy or Add-on', with: '100'
        click_button 'Rebuy or Add-on Only'

        expect(page).to have_content ('$100')
      end
    end
  end
end
