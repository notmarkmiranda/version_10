require 'rails_helper'

describe 'Api::V1::NotificationsController', type: :request do
  describe 'get#last_five' do
    subject(:get_last_five) { get api_v1_last_five_notifications_path }

    describe 'as a user' do
      let(:user) { create(:user) }
      let!(:notifications) { create_list(:notification, 5, recipient: user) }
      let(:expected_return) do
        notifications.map do |note|
          {
            "id" => note.id,
            "note_text" => note.notification_text
          }
        end
      end

      before do
        stub_current_user(user)
      end

      it 'returns 5 notifications' do
        get_last_five

        expect(JSON.parse(response.body)).to eq(expected_return)
      end
    end

    describe 'as a visitor' do
      it 'should return 401 unauthorized' do
        get_last_five

        expect(JSON.parse(response.body)).to eq('unauthorized')
        expect(response.status).to eq(401)
      end
    end
  end
end
