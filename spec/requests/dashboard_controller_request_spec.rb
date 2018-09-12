require 'rails_helper'

describe 'DashboardController', type: :request do
  context 'GET#show' do
    let(:user) { create(:user) }

    it 'renders the show template' do
      allow_any_instance_of(ApplicationController).to receive(:current_user) { user }
      get dashboard_path

      expect(response.status).to eq(200)
    end

    it 'redirects a visitor' do
      get dashboard_path

      expect(response.status).to eq(302)
    end
  end
end
