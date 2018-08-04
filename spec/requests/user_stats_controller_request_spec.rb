require 'rails_helper'

describe 'User Stats Controller' do
  let(:user) { create(:user) }
  let(:season) { create(:season) }

  context 'GET#show' do
    it 'renders the show template without query params' do
      get "/user_stats/#{user.id}"

      expect(response.status).to eq(200)
    end

    it 'renders the show template with query params' do
      get "/user_stats/#{user.id}?season_id=#{season.id}"

      expect(response.status).to eq(200)
    end
  end
end
