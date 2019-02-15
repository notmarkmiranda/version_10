require 'rails_helper'

describe 'user can request access on a public league' do
  describe 'as a user' do
    before { stub_current_user }

    it 'should allow a user to request access to a public league they do not belong to' do
      visit leagues_path

      click_button 'Request Membership'

      expect(page).to have_content public_league.name
      expect(page).not_to have_button 'Request Membership'
    end
  end

  describe 'as a visitor'
end
