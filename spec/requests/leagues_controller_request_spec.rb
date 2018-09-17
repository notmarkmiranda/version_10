require 'rails_helper'

describe 'League Controller', type: :request do
  context 'GET#show' do
    let(:league) { create(:league, privated: false) }

    before do
      create(:season, league: league)
    end

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
        stub_current_user(user)
        league.update(privated: true)
      end

      context 'is the creator' do
        let(:user) { league.user }
        before do
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

  context 'GET#new' do
    subject { get new_league_path }
    context 'visitor' do
      it 'redirects to root path' do
        subject

        expect(response.status).to be(302)
      end
    end

    context 'logged-in user' do
      before do
        stub_current_user
      end

      it 'renders the new template' do
        subject

        expect(response.status).to eq(200)
      end
    end
  end

  context 'POST#create' do
    let(:attrs) { attributes_for(:league) }
    context 'visitor' do
      it 'redirects to root path' do
        expect {
          post leagues_path, params: { league: attrs }
        }.to_not change(League, :count)

        expect(response.status).to eq(302)
      end
    end

    context 'logged-in user' do
      before do
        stub_current_user
      end

      it 'redirects to league show page - successful create' do
        expect {
          post leagues_path, params: { league: attrs }
        }.to change(League, :count).by(1)

        expect(response.status).to eq(302)
      end

      it 'redirects to league new page - unsuccessful create' do
        expect {
          post leagues_path, params: { league: { name: '' } }
        }.to_not change(League, :count)

        expect(response.status).to eq(200)
      end
    end
  end
end
