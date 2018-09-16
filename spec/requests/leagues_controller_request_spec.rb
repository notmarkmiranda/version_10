require 'rails_helper'

describe 'League Controller', type: :request do
  let(:league) { create(:league, privated: false) }

  before do
    create(:season, league: league)
  end

  context 'GET#show' do
    context 'visitor' do
      it 'renders the show template on a public league' do
        get league_path(league)

        expect(response.status).to eq(200)
      end

      it 'redirects to the root path' do
        league.update(privated: true)
        get league_path(league)

        expect(response.status).to eq(302)
      end
    end

    context 'logged-in user' do
      before do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
        league.update(privated: true)
      end

      context 'is the creator' do
        let(:user) { league.user }
        before do
          create(:membership, user: user, league: league, role: 1)
          get league_path(league)
        end

        it 'renders the show template' do
          expect(response.status).to eq(200)
        end
      end

      context 'is a member' do
        let(:game) { create(:game, season: league.current_season) }
        let(:player) { create(:player, game: game) }
        let(:user) { player.user }

        before do
          create(:membership, user: user, league: league, role: 0)
          get league_path(league)
        end

        it 'renders the show template' do
          expect(response.status).to eq(200)
        end
      end

      context 'is not a member or an owner' do
        let(:user) { create(:user) }

        before do
          get league_path(league)
        end

        it 'redirects to root path' do
          expect(response.status).to eq(302)
        end
      end
    end
  end
end
