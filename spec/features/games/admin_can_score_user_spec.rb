require 'rails_helper'

describe 'Admin can score a user', type: :feature do
  let(:game) { create(:game) }
  let(:league) { game.league }
  let(:admin) { league.user }

  context 'As an admin' do
    before do
      stub_current_user(admin)
      @users = create_list(:membership, 2, league: league).map(&:user)
    end

    it 'allows a user to be scored' do
      visit game_path(game)

      find('#player_user_id').find(:xpath, 'option[2]').select_option
      click_button 'Score Player'

      within '.standings-list' do
        expect(page).to have_content(@users[0].full_name)
      end
    end
  end

  context 'As a user'
end
