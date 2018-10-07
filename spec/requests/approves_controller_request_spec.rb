require 'rails_helper'

describe ApprovesController, type: :request do
  let(:league) { create(:league) }
  let(:admin) { league.user }
  let(:membership) do
    create(:membership,
           league: league,
           requestor: requestor)
  end

  subject { patch membership_approve_path(membership_id: membership.id); membership.reload }

  context 'PATCH#update' do
    context 'When the user is the requestor' do
      let(:requestor) { create(:user) }

      it 'approves the membership - success' do
        stub_current_user(admin)

        expect { subject }
          .to change { membership.decider }.to(admin)
          .and change { membership.status }.to('approved')
      end

      it 'does not change the decider on an already approved membership request' do
        membership.update(decider: create(:user))
        stub_current_user(admin)

        expect { subject }
          .to not_change { membership.decider }
          .and not_change { membership.status }
      end

      it 'does not allow a non-admin to approve a membership request' do
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
        stub_current_user(membership.requestor)

        expect { subject }
          .to not_change { membership.decider }
          .and not_change { membership.status }
      end
    end

    context 'when the admin is the requestor' do
      let(:requestor) { admin }

      it 'approves the membership - success' do
        stub_current_user(membership.user)

        expect { subject }
          .to change { membership.decider }.to(membership.user)
          .and change { membership.status }.to('approved')
      end

      it 'does not change the decider on an already approved membership request' do
        membership.update(decider: admin, status: 1)
        stub_current_user(membership.user)

        expect { subject }
          .to not_change { membership.decider }
          .and not_change { membership.status }
      end

      it 'does not allow another admin to approve the request' do
        m = create(:membership,
                   league: league,
                   role: 1)
        other_admin = m.user
        stub_current_user(other_admin)

        expect { subject }
          .to not_change { membership.decider }
          .and not_change { membership.status }
      end

      it 'does not allow the requestor to approve the request' do
        stub_current_user(admin)

        expect { subject }
          .to not_change { membership.decider }
          .and not_change { membership.status }
      end

      it 'does not allow another league member to approve the request' do
        m = create(:membership,
                   league: league,
                   role: 0)
        other_user = m.user
        stub_current_user(other_user)

        expect { subject }
          .to not_change { membership.decider }
          .and not_change { membership.status }
      end

      it 'does not allow a random user to approve the request' do
        stub_current_user

        expect { subject }
          .to not_change { membership.decider }
          .and not_change { membership.status }
      end
    end
  end
end
