require 'rails_helper'

describe MembershipsController, type: :request do
  describe 'GET#show' do
    let(:league) { create(:league) }
    let(:membership) { create(:membership, requestor: requestor, league: league) }
    let(:notification) { create(:notification, notifiable: membership) }
    let(:admin) { league.user }

    subject { get membership_path(membership, notification_id: notification.id) }
    describe 'request from user' do
      let(:requestor) { create(:user) }

      it 'renders the show template - admin' do
        stub_current_user(admin)
        subject

        expect(response.status).to eq(200)
      end

      it 'renders the show template - membership_user' do
        stub_current_user(membership.user)
        subject

        expect(response.status).to eq(200)
      end

      it 'redirects to root path - visitor' do
        subject

        expect(response.status).to eq(302)
      end

      it 'redirects to dashboard path - user' do
        stub_current_user
        subject

        expect(response.status).to eq(302)
      end
    end

    describe 'request from admin' do
      let(:requestor) { admin }

      it 'renders the show template - membership_user' do
        stub_current_user(membership.user)
        subject

        expect(response.status).to eq(200)
      end

      it 'renders the show template - admin' do
        stub_current_user(admin)
        subject

        expect(response.status).to eq(200)
      end

      it 'redirects to root path - visitor' do
        subject

        expect(response.status).to eq(302)
      end

      it 'redirects to dashboard path - user' do
        stub_current_user
        subject

        expect(response.status).to eq(302)
      end
    end
  end
end
