require 'rails_helper'

describe 'Games Controller', type: :request do
  let(:league) { create(:league) }
  let(:user) { league.user }
  let(:game) { create(:game, season: league.current_season) }

  context 'GET#new' do
    before do
      stub_current_user(user)
      get "/games/new?league_id=#{league.id}"
    end

    context 'for authorized admin' do
      it 'renders the new template' do
        expect(response.status).to eq(200)
      end
    end

    context 'for league member' do
      let(:membership) { create(:membership, league: league, role: 0) }
      let(:user) { membership.user }

      it 'redirects the member' do
        expect(response.status).to eq(302)
      end
    end
  end

  context 'POST#create' do
    let(:game_params) do
      { season_id: league.current_season.id, date: Date.tomorrow, buy_in: 100 }
    end

    before do
      stub_current_user(user)
    end

    subject(:post_games) do
      post '/games', params: { game: game_params }
    end

    context 'for authorized admin' do
      let(:user) { league.user }

      it 'redirects to game_path' do
        expect {
          post_games
        }.to change { Game.count }.by(1)
        expect(response.status).to eq(302)
      end
    end
  end

  context 'GET#show' do
    it 'renders the show template' do
      get "/games/#{game.id}"

      expect(response.status).to eq(200)
    end
  end

  context 'POST#complete' do
    subject(:complete_game) do
      post "/games/#{game.id}/complete"
    end

    context 'as an admin' do
      before { stub_current_user(user) }

      context 'with at least 2 players finished' do
        before { create_list(:player, 2, game: game) }

        it 'redirects back to game_path' do
          expect {
            complete_game
          }.to change { game.reload.completed }.from(false).to(true)
        end
      end

      context 'with exactly 1 player finished and does not complete a game' do
        before { create(:player, game: game) }

        it 'redirects back to game_path' do
          expect {
            complete_game
          }.not_to change { game.reload.completed }.from(false)
        end
      end

      context 'with exactly 0 players finished' do
        it 'redirects back to game_path and does not complete a game' do
          expect {
            complete_game
          }.not_to change { game.reload.completed }.from(false)
        end
      end
    end

    context 'as a non-admin' do
      let(:membership) { create(:membership, role: 0) }
      let(:regular_user) { membership.user }

      before do
        create_list(:player, 3, game: game)
        stub_current_user(regular_user)
      end

      it 'redirects back to game_path and does not complete a game' do
        expect {
          complete_game
        }.not_to change { game.reload.completed }.from(false)
      end
    end
  end

  context 'POST#uncomplete' do
    subject(:uncomplete_game) do
      post "/games/#{game.id}/uncomplete"
    end

    before { game.complete! }
    
    context 'as an admin' do
      before { stub_current_user(user) }

      context 'with at least 2 players finished' do
        before { create_list(:player, 2, game: game) }

        it 'redirects back to game_path' do
          expect {
            uncomplete_game
          }.to change { game.reload.completed }.from(true).to(false)
        end
      end
    end

    context 'as a non-admin' do
      let(:membership) { create(:membership, role: 0) }
      let(:regular_user) { membership.user }

      before do
        create_list(:player, 3, game: game)
        stub_current_user(regular_user)
      end

      it 'redirects back to game_path and does not complete a game' do
        expect {
          uncomplete_game
        }.not_to change { game.reload.completed }.from(true)
      end
    end
  end
end
