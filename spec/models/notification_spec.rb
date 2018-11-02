require 'rails_helper'

describe Notification, type: :model do
  context 'relationships' do
    it { should belong_to :recipient }
    it { should belong_to :actor }
    it { should belong_to :notifiable }
  end
  context 'validations'
  context 'methods' do
    context '#can_be_read?' do
      let(:notification) { create(:notification, read_at: nil) }
      subject { notification.can_be_read? }

      it 'returns true' do
        expect(subject).to be true
      end

      it 'returns false' do
        notification.update(read_at: Time.current)

        expect(subject).to be false
      end
    end

    context '#has_decision' do
      let(:membership) { create(:membership, status: 'pending') }

      before do
        notification.update(notifiable: membership)
      end

      context 'for membership' do
        subject { notification.has_decision? }

        it 'returns true for approved' do
          membership.update(status: 'approved')

          expect(subject).to be true
        end

        it 'returns true for rejected' do
          membership.update(status: 'rejected')

          expect(subject).to be true
        end

        it 'returns false for pending' do
          expect(subject).to be false
        end
      end
    end

    context '#mark_as_read!' do
      subject { notification.mark_as_read! }

      it 'updates the read_at' do
        expect { subject }.to change { notification.read_at }
      end

      it 'does not update the read_at' do
        notification.update(read_at: Date.yesterday)

        expect { subject }.to_not change { notification.read_at }
      end
    end

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

    context '#read_at_class' do
      subject { notification.read_at_class }

      it 'returns notification-unread' do
        expect(subject).to eq('notification-unread')
      end

      it 'returns notification-read' do
        notification.update(read_at: Time.current)

        expect(subject).to eq('notification-read')
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
