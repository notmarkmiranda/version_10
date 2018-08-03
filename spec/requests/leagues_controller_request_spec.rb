require 'rails_helper'

describe 'League Controller', type: :request do
  let(:league) { create(:league) }

  before do
    create(:season, league: league)
  end

  context 'GET#show' do
    it 'renders the show template' do
      get league_path(league)

      expect(response.status).to eq(200)
    end
  end
end