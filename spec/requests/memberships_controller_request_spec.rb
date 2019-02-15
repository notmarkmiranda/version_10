require 'rails_helper'

describe MembershipsController, type: :request do
  let!(:league) { create(:league) }

  describe 'GET#show' do
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

  describe 'POST#create' do
    let(:user) { create(:user) }
    let(:membership_params) { { league_id: league.id, user_id: user.id } }
    subject(:post_new_membership) do
      post memberships_path, params: { membership: membership_params }, headers: { 'HTTP_REFERER' => leagues_path}
    end

    before { stub_current_user(user) }

    it 'should create a new membership' do
      expect {
        post_new_membership
      }.to change(Membership, :count).by 1
      expect(response).to redirect_to leagues_path
    end

    it 'should not create a new membership if one already exists for a league for a user' do
      create(:membership, league: league, user: user)
      expect {
        post_new_membership
      }.not_to change(Membership, :count)
      expect(response).to redirect_to leagues_path
    end
  end
end
