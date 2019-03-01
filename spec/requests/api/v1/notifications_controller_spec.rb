require 'rails_helper'

describe 'Api::V1::NotificationsController', type: :request do
  let(:user) { create(:user) }
  let!(:notifications) { create_list(:notification, 5, recipient: user, read_at: nil) }

  describe 'get#last_five' do
    subject(:get_last_five) { get api_v1_last_five_notifications_path }

    describe 'as a user' do
      let(:expected_return) do
        notifications.sort_by(&:created_at).reverse.map do |note|
          {
            "id" => note.id,
            "note_text" => note.notification_text,
            "read_at" => note.read_at,
            "decorated_created_at" => note.decorate.decorated_created_at
          }
        end
      end

      before { stub_current_user(user) }

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

  describe 'patch#mark_as_read' do
    let(:notification) { notifications.first }
    subject(:mark_single_notification_as_read) { patch mark_as_read_api_v1_notification_path(notification) }
    subject(:mark_all_notifications_as_read) { patch mark_as_read_api_v1_notifications_path }

    describe 'as a user' do
      describe 'for a single notification' do

        before { stub_current_user(user) }

        it 'should mark the notification as read' do
          expect {
            mark_single_notification_as_read
          }.to change { notification.reload.read_at }.from nil
        end
      end

      describe 'for a notification collection' do
        describe 'for a collection of notifications' do

          before { stub_current_user(user) }

          it 'should mark the whole collection as read' do
            mark_all_notifications_as_read
            notifications.map(&:reload)
            expect(notifications.pluck(:read_at).compact).not_to be_empty
          end
        end
      end
    end

    describe 'as a visitor' do
      describe 'for a single notification' do
        it 'should return 401 unauthorized' do
          mark_single_notification_as_read

          expect(JSON.parse(response.body)).to eq('unauthorized')
          expect(response.status).to eq(401)
        end
      end

      describe 'for a notification collection' do
        it 'should return 401 unauthorized' do
          mark_all_notifications_as_read

          expect(JSON.parse(response.body)).to eq('unauthorized')
          expect(response.status).to eq(401)
        end
      end
    end
  end
end
