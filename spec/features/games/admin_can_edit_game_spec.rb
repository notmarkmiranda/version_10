require 'rails_helper'

describe 'Admin can edit a game' do
  let(:game) { create(:game, buy_in: 15, date: Date.today, completed: false) }
  let(:user) { game.league.user }

  describe 'for an admin' do

    describe 'for an uncomplete game' do
      before do
        stub_current_user user

        visit game_path(game)

        expect(page).to have_content "Buy In: $15"
        expect(page).to have_content "Date: #{Date.today.strftime('%B %-e, %Y')}"
      end

      before do
        click_link 'Edit Game'
      end

      it 'should update the buy in on a game' do
        fill_in 'Buy In Amount', with: '100'
        click_button 'Update Game'

        expect(page).to have_content "Buy In: $100"
        expect(page).not_to have_content "Buy In: $15"
      end

      it 'should update the date on a game' do
        fill_in 'Date', with: Date.tomorrow
        click_button 'Update Game'

        expect(page).to have_content "Date: #{Date.tomorrow.strftime('%B %-e, %Y')}"
        expect(page).not_to have_content "Date: #{Date.today.strftime('%B %-e, %Y')}"
      end
    end

    describe 'for a complete game' do
      before do
        game.update(completed: true)
        visit game_path(game)
      end

      it 'should not have a link to edit game' do
        expect(page).to have_content("Date: #{Date.today.strftime('%B %-e, %Y')}")
        expect(page).not_to have_link("Edit Game")
      end
    end
  end

  describe 'for a regular user'
end
