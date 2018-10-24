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

  context 'GET#show' do
    let(:notification) { create(:notification) }
    it 'renders the show template - user' do
      stub_current_user(notification.actor)

      get notification_path(notification)
      expect(response.status).to eq(200)
    end

    it 'redirects a non-participating user' do
      stub_current_user

      get notification_path(notification)
      expect(response.status).to eq(302)
    end

    it 'redirects to root path - visitor' do
      get notification_path(notification)

      expect(response.status).to eq(302)
    end
  end
end
