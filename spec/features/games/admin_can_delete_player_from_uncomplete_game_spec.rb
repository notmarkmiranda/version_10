require 'rails_helper'

describe 'Admin can delete a player from an uncomplete game', type: :feature do
  let(:game) { create :game }
  let(:admin) { game.league.user }

  context 'As an admin' do
    before { stub_current_user admin }

    let(:deleted_user) { player.user }

    context 'for a finished player' do
      let!(:player) { create :player, game: game, finished_at: Time.now }

      it 'should allow to remove a player from the standings' do
        visit game_path game

        click_button 'Delete Player'

        within '.standings' do
          expect(page).not_to have_content deleted_user.full_name
        end
      end
    end

    context 'for a player with an additional_expense' do
      let!(:player) { create :player, game: game, additional_expense: 100 }

      it 'should allow to remove a player from the standings' do
        visit game_path game

        click_button 'Delete Player'

        within '.standings' do
          expect(page).not_to have_content deleted_user.full_name
        end
      end
    end
  end
  context 'As a non-admin' do
    let(:membership) { create :membership, role: 0, league: game.league }
    let(:non_admin) { membership.user }
    before { stub_current_user non_admin }

    let!(:player) { create :player, game: game, finished_at: Time.now }

    it 'should not see the delete button' do
      visit game_path game

      expect(page).to have_content(player.user_full_name)
      expect(page).not_to have_button 'Delete Player'
    end
  end
end
