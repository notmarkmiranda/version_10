require 'rails_helper'

describe 'as a logged in user on a game#show page' do
  let(:player) { create(:player) }
  let(:game) { player.game }
  let(:league) { game.league }
  let(:admin) { league.user }
  let(:membership) { create(:membership, league: league) }
  let(:user) { membership.user }

  before { game.update(completed: true) }

  let!(:new_game) do
    create(:game, season: league.seasons.last, date: Date.tomorrow, completed: false)
  end

  describe 'as an admin' do
    before { stub_current_user(admin) }

    describe 'and a game is not complete' do
      describe 'when there are not enough players to score a game' do
        before do
          visit game_path(new_game)
        end

        it 'has a disabled complete game button' do
          expect(page).to have_select('player_user_id', options: ["Choose a Player", admin.full_name])
          expect(page).to have_button('Complete Game', disabled: true)
        end
      end

      describe 'when there are just enough players to score a game' do
        before do
          2.times { create(:player, game: new_game) }
          visit game_path(new_game)
        end

        it 'has an enabled complete game button' do
          expect(page).to have_button('Complete Game', disabled: false)
        end
      end
    end

    describe 'and the game is already complete' do
      before do
        visit game_path(game)
      end

      it 'has an uncomplete button' do
        expect(page).to have_button('Uncomplete Game')
        expect(page).not_to have_select('player_user_id')
      end
    end
  end

  describe 'as a user' do
    before { stub_current_user(user) }

    describe 'and a game is not completed' do
      before do
        2.times { create(:player, game: new_game) }
        visit game_path(new_game)
      end

      it 'a non-admin is not able to see the complete button' do
        expect(page).to have_content("Standings")
        expect(page).not_to have_button("Complete Game")
        expect(page).not_to have_button("Uncomplete Game")
      end
    end
  end
end
