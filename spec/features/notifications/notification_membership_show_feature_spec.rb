require 'rails_helper'

describe 'when a user views a notification' do
  describe 'the user is an appropriate approving user' do
    let(:notification) { create(:notification) }

    before do
      stub_current_user(notification.recipient)
    end

    context 'and it has not been approved or rejected' do
      it 'has a button to approve or reject' do
        visit notification_path(notification)

        expect(page).to have_button('Approve')
        expect(page).to have_button('Reject')
      end
    end

    context 'and it has a decision'
    let(:admin_membership) { create(:membership, role: 1) }
    let(:other_admin) { admin_membership.user }
    let(:membership) { notification.notifiable }

    context 'approved' do
      before { membership.update(status: 1, decider: other_admin) }

      it 'has a disabled buttons for approve or reject' do
        visit notification_path(notification)

        expect(page).to have_button('Approve', disabled: true)
        expect(page).to have_button('Reject', disabled: true)
      end
    end

    context 'rejected' do
      before { membership.update(status: 2, decider: other_admin) }
      it 'has a disabled buttons for approve or reject' do
        visit notification_path(notification)

        expect(page).to have_button('Approve', disabled: true)
        expect(page).to have_button('Reject', disabled: true)
      end
    end
  end
end
