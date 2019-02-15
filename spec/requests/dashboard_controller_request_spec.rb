require 'rails_helper'

describe 'DashboardController', type: :request do
  describe 'GET#show' do
    it 'renders the show template' do
      stub_current_user
      get dashboard_path

      expect(response.status).to eq(200)
    end

    it 'redirects a visitor' do
      get dashboard_path

      expect(response.status).to eq(302)
    end
  end
end
