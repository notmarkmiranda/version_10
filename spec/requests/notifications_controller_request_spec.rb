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
    let(:notification) { create(:notification, read_at: nil) }
    it 'renders the show template - user' do
      stub_current_user(notification.actor)

      expect(notification.read_at).to be_nil

      get notification_path(notification)

      notification.reload
      expect(notification.read_at).to_not be_nil
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
