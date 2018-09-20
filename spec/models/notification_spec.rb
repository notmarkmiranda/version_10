require 'rails_helper'

describe Notification, type: :model do
  context 'relationships' do
    it { should belong_to :recipient }
    it { should belong_to :actor }
    it { should belong_to :notifiable }
  end
  context 'validations'
  context 'methods' do
    context '#dropdown_text' do
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
          expect(notification.dropdown_text).to eq(expected)
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
          expect(first.dropdown_text).to eq(expected)
          expect(second.dropdown_text).to eq(expected)
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
          expect(notification.dropdown_text).to eq(user_expected)
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
          expect(first.dropdown_text).to eq(admin_expected)
          expect(second.dropdown_text).to eq(user_expected)
        end
      end
    end

    context 'scope#unread' do
      let(:notification) { create(:notification, read_at: nil) }

      it 'returns only unread notifications' do
        read_notification = create(:notification, read_at: DateTime.now)

        expect(Notification.unread).to include(notification)
        expect(Notification.unread).to_not include(read_notification)
      end
    end
  end
end
