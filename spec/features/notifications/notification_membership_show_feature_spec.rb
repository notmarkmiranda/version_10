require 'rails_helper'

describe 'when a user views a notification' do
  let(:notification) { create(:notification) }
  let(:membership) { notification.notifiable }

  before { membership.update(requestor: notification.actor) }

  describe 'the user is an appropriate approving user' do
    before do
      stub_current_user(notification.recipient)
    end

    describe 'and it has not been approved or rejected' do
      it 'has a button to approve or reject' do
        visit notification_path(notification)

        expect(page).to have_button('Approve')
        expect(page).to have_button('Reject')
      end
    end

    describe 'and it has a decision'
    let(:admin_membership) { create(:membership, role: 1) }
    let(:other_admin) { admin_membership.user }

    describe 'approved' do
      before { membership.update(status: 1, decider: other_admin) }

      it 'has a disabled buttons for approve or reject' do
        visit notification_path(notification)

        expect(page).to have_button('Approve', disabled: true)
        expect(page).to have_button('Reject', disabled: true)
      end
    end

    describe 'rejected' do
      before { membership.update(status: 2, decider: other_admin) }
      it 'has a disabled buttons for approve or reject' do
        visit notification_path(notification)

        expect(page).to have_button('Approve', disabled: true)
        expect(page).to have_button('Reject', disabled: true)
      end
    end
  end

  describe 'the user is the requestor' do
    before do
      stub_current_user(notification.actor)
    end

    it 'should not allow the user to view buttons on the notification page' do
      visit notification_path(notification)

      expect(page).to have_content(notification.notification_text)
      expect(page).to_not have_button('Approve')
      expect(page).to_not have_button('Reject')
    end
  end
end
