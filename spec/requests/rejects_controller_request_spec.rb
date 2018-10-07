require 'rails_helper'

describe RejectsController, type: :request do
  context 'PATCH#update' do
    let(:league) { create(:league) }
    let(:admin) { league.user }
    let(:membership) do
      create(:membership,
             league: league)
    end
    let(:user) { membership.user }

    subject { patch membership_reject_path(membership_id: membership.id); membership.reload }

    context 'When the user is the requestor' do
      before do
        membership.update(requestor: user)
      end

      it 'rejects the membership - success' do
        stub_current_user(admin)

        expect { subject }
          .to change { membership.decider }.to(admin)
          .and change { membership.status }.to('rejected')
      end

      it 'does not change the decider on an already rejected membership request' do
        membership.update(decider: create(:user))

        expect { subject }
          .to not_change { membership.decider }
          .and not_change { membership.status }
      end

      it 'does not allow a league user to approve a membership request' do
        m = create(:membership,
                   role: 0,
                   league: league)
        user = m.user
        stub_current_user(user)

        expect { subject }
          .to not_change { membership.decider }
          .and not_change { membership.status }
      end
      it 'does not allow a requestor to approve a membership request' do
        stub_current_user(user)

        expect { subject }
          .to not_change { membership.decider }
          .and not_change { membership.status }
      end
    end

    context 'When the admin is the requestor' do
      before do
        membership.update(requestor: admin)
      end

      it 'rejects the membership - success' do
        stub_current_user(user)

        expect { subject }
          .to change { membership.decider }.to(user)
          .and change { membership.status }.to('rejected')
      end

      it 'does not change the decider on an already rejected membership request' do
        membership.update(decider: create(:user))
        stub_current_user(user)

        expect { subject }
          .to not_change { membership.decider }
          .and not_change { membership.status }
      end

      it 'does not allow another admin to reject the request' do
        m = create(:membership,
                   role: 1,
                   league: league)
        other_admin = m.user
        stub_current_user(other_admin)

        expect { subject }
          .to not_change { membership.decider }
          .and not_change { membership.status }
      end

      it 'does not allow the requestor to reject the request' do
        stub_current_user(admin)

        expect { subject }
          .to not_change { membership.decider }
          .and not_change { membership.status }
      end

      it 'does not allow a league member to reject the request' do
        m = create(:membership,
                   role: 0,
                   league: league)
        other_member = m.user
        stub_current_user(other_member)

        expect { subject }
          .to not_change { membership.decider }
          .and not_change { membership.status }
      end

      it 'does not allow a random user to reject the request' do
        stub_current_user

        expect { subject }
          .to not_change { membership.decider }
          .and not_change { membership.status }
      end
    end
  end
end
