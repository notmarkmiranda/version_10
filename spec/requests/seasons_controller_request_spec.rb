require 'rails_helper'

describe 'Season Controller', type: :request do
  context 'GET#show' do
    let(:season) { create(:season) }
    it 'renders the show template' do
      get "/seasons/#{season.id}"

      expect(response.status).to eq(200)
    end
  end
end
