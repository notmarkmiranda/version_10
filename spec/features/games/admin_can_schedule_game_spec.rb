require 'rails_helper'

describe 'Admin can schedule a game', type: :feature do
  let(:league) { create(:league) }
  let(:admin)  { league.user }
  describe 'when an admin is logged in' do
    before do
      stub_current_user(admin)
    end

    describe 'and there is an active season' do
      it 'allows them to schedule a game' do
        visit league_path(league)
        click_link 'Schedule Game'
        fill_in 'Date', with: '09/05/2020'
        fill_in 'Buy In Amount', with: '100'
        click_button('Create Game')

        expect(current_path).to eq(game_path(Game.last))
        expect(page).to have_content('May 9, 2020')
        expect(page).to have_content('$100.00')
      end
    end

    describe 'and there is not an active season'
  end

  describe 'when a member is logged in' do
    let(:membership) { create(:membership, league: league, role: 0) }
    let(:member) { membership.user }

    before do
      stub_current_user(member)
    end

    describe 'and there is an active season' do
      it 'does not allow them to schedule a game' do
        visit league_path(league)

        expect(page).to have_content(league.name)
        expect(page).to_not have_content('Schedule Game')
      end
    end
    describe 'and there is not an active season'
  end
end
