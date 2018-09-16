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
  end
end
