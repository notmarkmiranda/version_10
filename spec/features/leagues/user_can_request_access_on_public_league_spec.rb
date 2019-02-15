require 'rails_helper'

describe 'user can request access on a public league' do
  let!(:public_league) { create(:league, privated: false) }
  describe 'as a user' do
    describe 'who does not belong to the league' do
      before { stub_current_user }

      it 'should allow a user to request access to a public league they do not belong to' do
        visit leagues_path

        click_button 'Request Membership'

        expect(page).to have_content public_league.name
        expect(page).not_to have_button 'Request Membership'
      end
    end

    describe 'who already belongs as a member' do
      let(:member) { create(:membership, league: public_league, role: 0).user }
      before { stub_current_user(member) }

      it 'should not show a Request Membership button' do
        visit leagues_path

        expect(page).to have_content public_league.name
        expect(page).not_to have_button 'Request Membership'
      end
    end

    describe 'who is an admin for the league' do
      let(:admin) { create(:membership, league: public_league, role: 1).user }
      before { stub_current_user(admin) }

      it 'should not show a Request Membership button' do
        visit leagues_path

        expect(page).to have_content public_league.name
        expect(page).not_to have_button 'Request Membership'
      end
    end

    describe 'who is an admin for another league' do
      let(:admin) { create(:membership, role: 1).user }
      before { stub_current_user(admin) }

      it 'should allow admin to request membership on another league' do
        visit leagues_path

        click_button 'Request Membership'

        expect(page).to have_content public_league.name
        expect(page).not_to have_button 'Request Membership'
      end
    end
  end

  describe 'as a visitor' do
    it 'should not show a Request Membership button' do
      visit leagues_path

      expect(page).to have_content 'Public Leagues'
      expect(page).not_to have_button 'Request Membership'
    end
  end
end
