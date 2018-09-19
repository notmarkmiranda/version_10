require 'rails_helper'

describe Membership, type: :model do
  context 'validations' do
    before { create(:membership, role: 1) }
    it { should validate_presence_of :user_id }
    it { should validate_presence_of :league_id }
    it { should validate_uniqueness_of(:user_id).scoped_to(:league_id) }
    xit { should validate_numericality_of(:role).only_integer }
  end

  context 'relationships' do
    it { should belong_to :user }
    it { should belong_to :league }
    it { should belong_to(:requestor) }
  end

  context 'methods' do
    let(:membership) { create(:membership) }
    context 'enums' do
      it '#member' do
        membership.update!(role: 0)

        expect(membership.member?).to be true
        expect(membership.admin?).to be false
        expect(membership.role).to eq('member')
      end

      it 'admin' do
        membership.update!(role: 1)

        expect(membership.admin?).to be true
        expect(membership.member?).to be false
        expect(membership.role).to eq('admin')
      end
    end

    context 'after_create#recipients' do
      let!(:league) { create(:league) }
      let(:admin) { league.user }
      let(:user) { create(:user) }

      let(:membership) do
        create(:membership,
                user: user,
                league: league,
                role: 0,
                skip_notification: false,
                requestor: current_user)
      end

      subject { membership.send('recipients') }
      context 'no current_user' do
        let(:current_user) { nil }
        it 'creates 2 notifications' do
          expect(subject.count).to eq(2)
        end
      end

      context 'current_user: admin' do
        let(:current_user) { admin }
        it 'creates 1 notification' do
          expect(subject.count).to eq(1)
          expect(subject).to include(user)
        end
      end

      context 'current_user: user' do
        let(:current_user) { user }
        it 'creates 1 notification' do
          expect(subject.count).to eq(1)
          expect(subject).to include(admin)
        end
      end
    end

    context 'after_create#create_notifications' do
      let(:league) { create(:league) }
      let(:admin) { league.user }
      let(:user) { create(:user) }
      let(:membership) do
        create(:membership,
               user: user,
               league: league,
               role: role,
               skip_notification: skip,
               requestor: current_user)
      end

      context 'skipped' do
        let(:role) { 1 }
        let(:skip) { true }
        let(:current_user) { nil }

        it 'does not create any new notifications' do
          expect { membership }.to_not change(Notification, :count)
        end
      end

      context 'sent from admin' do
        let(:role) { 0 }
        let(:skip) { false }
        let(:current_user) { admin }

        it 'creates 1 notification for user' do
          expect { membership }.to change(Notification, :count).by(1)
          notification = Notification.last
          expect(notification.recipient).to eq(user)
        end

        it 'creates 2 notifications: 1 for user, 1 for other admin' do
          m = create(:membership, league: league, role: 1, skip_notification: true)
          other_admin = m.user

          expect { membership }.to change(Notification, :count).by(2)

          first, second = Notification.all

          expect(first.recipient).to eq(other_admin)
          expect(second.recipient).to eq(user)
        end
      end

      context 'sent from user' do
        let(:current_user) { user }
        let(:role) { 1 }
        let(:skip) { false }

        it 'creates notifications for admin' do
          expect { membership }.to change(Notification, :count).by(1)
          expect(Notification.last.recipient).to eq(admin)
        end

        it 'creates notifications for 3 admins' do
          m2 = create(:membership, league: league, role: 1, skip_notification: true)
          m3 = create(:membership, league: league, role: 1, skip_notification: true)
          admin2 = m2.user
          admin3 = m3.user

          expect { membership }.to change(Notification, :count).by(3)

          first, second, third = Notification.all

          expect(first.recipient).to eq(admin)
          expect(second.recipient).to eq(admin2)
          expect(third.recipient).to eq(admin3)
        end
      end
    end
  end
end
