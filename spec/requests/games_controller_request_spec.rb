require 'rails_helper'

describe 'Games Controller', type: :request do
  context 'GET#new' do
    let(:league) { create(:league) }

    before do
      stub_current_user(user)
      get "/games/new?league_id=#{league.id}"
    end

    context 'for authorized admin' do
      let(:user) { league.user }

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

  context 'POST#create'

  context 'GET#show' do
    let(:game) { create(:game) }
    it 'renders the show template' do
      get "/games/#{game.id}"

      expect(response.status).to eq(200)
    end
  end
end
