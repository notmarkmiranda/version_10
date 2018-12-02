require 'rails_helper'

describe 'as a logged in user on a league#show page' do
  let(:player) { create(:player) }
  let(:game) { player.game }
  let(:league) { game.league }
  let(:admin) { league.user }
  let(:membership) { create(:membership, league: league) }
  let(:user) { membership.user }

  before { game.update(completed: true) }

  describe 'as an admin' do
    before { stub_current_user(admin) }

    describe 'and a game is not complete' do
      before do
        create(:game, season: league.seasons.last, date: Date.tomorrow, completed: false)
      end

      it 'shows a score link and complete button' do
        visit league_path(league)

        expect(page).to have_content(league.name)
        expect(page).to have_button('Complete Game')
        expect(page).to have_link('Score Game')
      end
    end

    describe 'and no games are incomplete' do
      it_behaves_like 'non-admin game cell'
    end
  end

  describe 'as a user' do
    before { stub_current_user(user) }

    describe 'and a game is not complete' do
      before do
        create(:game, season: league.seasons.last, date: Date.tomorrow, completed: false)
      end

      it_behaves_like 'non-admin game cell'
    end

    describe 'and a no games are incomplete' do
      it_behaves_like 'non-admin game cell'
    end
  end
end
