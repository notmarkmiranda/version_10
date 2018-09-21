require 'rails_helper'

describe NotificationsController, type: :request do
  context 'GET#index' do
    it 'renders the index template - user' do
      stub_current_user
      get notifications_path

      expect(response.status).to eq(200)
    end

    it 'redirects to root path - visitor' do
      get notifications_path

      expect(response.status).to eq(302)
    end
  end
end
