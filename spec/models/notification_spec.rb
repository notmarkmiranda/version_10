require 'rails_helper'

describe Notification, type: :model do
  context 'relationships' do
    it { should belong_to :recipient }
    it { should belong_to :actor }
    it { should belong_to :notifiable }
  end
  context 'validations'
  context 'methods' do
    context '#notification_text' do
      let(:league) { create(:league) }
      let(:admin) { league.user }
      let(:user) { create(:user) }
      let(:membership) do
        create(:membership,
                user: user,
                requestor: requestor,
                league: league)
      end

      context 'from user to admins' do
        let(:requestor) { user }
        let(:expected) { "#{user.full_name} requested to join #{league.name}" }

        it 'to one admin' do
          expect {
            membership
          }.to change(Notification, :count).by(1)

          notification = Notification.last
          expect(notification.notification_text).to eq(expected)
        end

        it 'to multiple admins' do
          create(:membership,
                 requestor: nil,
                 league: league,
                 role: 1,
                 skip_notification: true)

          expect {
            membership
          }.to change(Notification, :count).by(2)

          first, second = Notification.all
          expect(first.notification_text).to eq(expected)
          expect(second.notification_text).to eq(expected)
        end
      end

      context 'from admin' do
        let(:requestor) { admin }
        let(:user_expected) do
          "#{admin.full_name} would like to add you to #{league.name}"
        end

        it 'to user' do
          expect {
            membership
          }.to change(Notification, :count).by(1)

          notification = Notification.last
          expect(notification.notification_text).to eq(user_expected)
        end

        it 'to another admin' do
          create(:membership,
                 requestor: nil,
                 league: league,
                 role: 1,
                 skip_notification: true)

          expect {
            membership
          }.to change(Notification, :count).by(2)
          first, second = Notification.last(2)

          admin_expected = "#{admin.full_name} is adding #{user.full_name} to #{league.name}"
          expect(first.notification_text).to eq(admin_expected)
          expect(second.notification_text).to eq(user_expected)
        end
      end
    end

    let(:notification) { create(:notification, read_at: nil) }
    let(:notification_2) { create(:notification, read_at: nil) }
    let(:read_notification) { create(:notification, read_at: DateTime.now) }
    let(:read_notification_2) { create(:notification, read_at: DateTime.now) }
    context 'scope#unread' do

      it 'returns only unread notifications' do
        expect(Notification.unread).to include(notification)
        expect(Notification.unread).to_not include(read_notification)
      end
    end

    context 'scope#ordered' do
      it 'returns unread notifications before read notifications' do
        notification; read_notification;
        read_notification_2
        notification_2

        ordered_array = [notification_2, notification, read_notification_2, read_notification]
        expect(Notification.ordered.to_a).to eq(ordered_array)
      end
    end
  end
end
