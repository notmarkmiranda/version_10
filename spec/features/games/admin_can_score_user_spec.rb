require 'rails_helper'

describe 'Admin can score a user', type: :feature do
  let(:game) { create(:game, date: DateTime.new(2015, 5, 9, 17, 30, 00)) }
  let(:league) { game.league }
  let(:admin) { league.user }

  describe 'As an admin' do
    before do
      stub_current_user(admin)
      @users = create_list(:membership, 2, league: league, status: :approved).map(&:user)
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

  describe 'As a user'
  describe 'As a visitor' do
    before do
      create_list(:membership, 2, league: league)
    end

    it 'does not show the dropdown for selecting users' do
      visit game_path game

      expect(page).to have_content 'Date: May 9, 2015'
      expect(page).not_to have_css 'select#player_user_id'
    end
  end
end
