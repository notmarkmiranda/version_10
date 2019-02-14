require 'rails_helper'

describe 'as a logged in user on a game#show page' do
  let(:game) { create(:game) }
  let(:league) { game.league }
  let(:admin) { league.user }

  describe 'as an admin' do
    before { stub_current_user(admin) }
    describe 'with at least 2 finished players' do
      before do
        create_list(:player, 2, game: game, finished_at: Time.now)
      end

      it 'allows the game to be completed and redirects back to the game path' do
        visit game_path(game)

        click_button 'Complete Game'

        expect(current_path).to eq(game_path(game))
        expect(page).not_to have_button('Complete Game')
        expect(page).to have_button('Uncomplete Game')
      end
    end
  end
end
