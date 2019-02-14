require 'rails_helper'

describe 'Admin can create user from game#show page' do
  let(:game) { create(:game) }
  let(:admin) { game.league.user }

  xdescribe 'as an admin' do
    before { stub_current_user(admin) }

    it 'allows a user to be created' do
      visit game_path game

      click_link 'Add a User'
      fill_in 'Email Address', with: 'markmiranda51@gmail.com'
      fill_in 'First Name', with: 'Mark'
      fill_in 'Last Name', with: 'Miranda'
      click_button 'Add User'

      expect(page).to have_select('player_user_id', selected: 'Mark Miranda')
      click_button 'Score Player'

      expect(page).to have_content('Mark Miranda')
    end
  end
  describe 'as a user'
end
