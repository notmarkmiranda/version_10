require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validations' do
    it { should validate_presence_of :email }
  end

  context 'relationships' do
    it { should have_many :leagues }
    it { should have_many :players }
  end

  context 'methods' do
    let(:user) { create(:user, first_name: 'Mark', last_name: 'Miranda') }
    context '#full_name' do
      subject { user.full_name }

      it 'returns the full name' do
        expect(subject).to eq('Mark Miranda')
      end
    end
  end
end
