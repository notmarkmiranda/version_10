require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validations' do
    it { should validate_presence_of :email }
  end

  context 'relationships' do
    it { should have_many :leagues }
    it { should have_many :players }
    it { should have_many :memberships }
  end

  context 'methods' do
    let(:user) { create(:user, first_name: 'Mark', last_name: 'Miranda') }
    let(:season) { double('season') }

    context '#attendance' do
      it 'returns an array of numbers' do
        expect(user).to receive(:get_attendance).with(season).and_return([1, 2])
        expect(user.attendance(season)).to eq([1, 2])
      end

      it 'returns an array when season is nil' do
        expect(user).to receive(:get_attendance).with(nil).and_return([3, 4])
        expect(user.attendance(nil)).to eq([3, 4])
      end
    end

    context '#full_name' do
      subject { user.full_name }

      it 'returns the full name' do
        expect(subject).to eq('Mark Miranda')
      end
    end

    context '#number_of_leagues_played_in' do
      subject { user.number_of_leagues_played_in }
      it 'returns 0' do
        expect(subject).to eq(0)
      end

      let(:one_league) { [double('league')] }

      it 'returns 1' do
        expect(user).to receive(:leagues_played_in).and_return(one_league)
        expect(subject).to eq(1)
      end

      let(:two_leagues) { [double('first league'), double('second league')] }
      it 'returns 2' do
        expect(user).to receive(:leagues_played_in).and_return(two_leagues)
        expect(subject).to eq(2)
      end
    end

    context '#leagues' do
      let(:admin_membership) { create(:membership, user: user, role: 1) }
      let(:reg_membership) { create(:membership, user: user, role: 0) }
      let(:admin_league) { admin_membership.league }
      let(:reg_league) { reg_membership.league }

      context '#owned_leagues' do
        subject { user.owned_leagues }

        it 'returns an empty array' do
          expect(subject).to eq([])
        end

        it 'returns the league' do
          admin_membership; reg_membership

          expect(subject).to eq([admin_league])
          expect(subject).to_not include(reg_league)
        end
      end

      context '#participated_leagues' do
        subject { user.participated_leagues }

        it 'returns an empty array' do
          expect(subject).to eq([])
        end

        it 'returns the league' do
          admin_membership; reg_membership

          expect(subject).to eq([reg_league])
          expect(subject).to_not include(admin_league)
        end
      end
    end

    context '#winner_calculation' do
      it 'returns an array of numbers' do
        expect(user).to receive(:get_winners).with(season).and_return([1, 2])
        expect(user.winner_calculation(season)).to eq([1, 2])
      end

      it 'returns an array when season is nil' do
        expect(user).to receive(:get_winners).with(nil).and_return([3, 4])
        expect(user.winner_calculation(nil)).to eq([3, 4])
      end
    end
  end
end
