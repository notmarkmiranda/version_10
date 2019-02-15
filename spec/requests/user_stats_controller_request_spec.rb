require 'rails_helper'

describe 'User Stats Controller' do
  let(:user) { create(:user) }
  let(:season) { create(:season) }

  describe 'GET#show' do
    it 'renders the show template without query params' do
      get "/user_stats/#{user.id}"

      expect(response.status).to eq(200)
    end

    it 'renders the show template with query params' do
      expect(Season).to receive(:find).with(season.id.to_s).and_return(season)
      get "/user_stats/#{user.id}?season=#{season.id}"

      expect(response.status).to eq(200)
    end
  end
end
