require 'rails_helper'

describe 'Games Controller', type: :request do
  context 'GET#show' do
    let(:game) { create(:game) }
    it 'renders the show template' do
      get "/games/#{game.id}"

      expect(response.status).to eq(200)
    end
  end
end
