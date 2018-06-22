require 'rails_helper'

RSpec.describe League, type: :model do
  context 'validations' do
    it { should validate_presence_of :user }
    it { should validate_presence_of :name }
  end

  context 'relationships' do
    it { should belong_to :user }
    it { should have_many :seasons }
    it { should delegate_method(:count).to(:seasons).with_prefix(true) }
    it { should delegate_method(:count).to(:games).with_prefix(true) }
    it { should delegate_method(:count).to(:players).with_prefix(true) }
  end

  context 'methods' do
    let(:league) { create(:league) }
    let!(:first_season) { create(:season, league: league) }
    let!(:second_season) { create(:season, league: league, active: true) }

    context '#current_season' do
      subject { league.current_season }

      it 'returns the last season' do
        allow(league.seasons).to receive(:find_by).with(active: true).and_return(first_season)

        expect(subject).to eq(first_season)
      end

      it 'returns the active season' do
        expect(subject).to eq(second_season)
      end
    end

    context '#current_season_leader' do
      subject { league.current_season_leader }

      it 'returns No One for no one' do
        expect(subject).to eq('No One')
      end

      context 'with players' do
        let(:game) { create(:game, season: second_season, buy_in: 15) }

        before do
          league.user.update(first_name: 'Mark', last_name: 'Miranda')
          create(:player, user: league.user, game: game, finishing_place: 2)
        end

        it 'returns the only person for a single user' do
          expect(subject).to eq('Mark Miranda')
        end

        it 'returns the leader for multiple users' do
          new_user = create(:user, first_name: 'John', last_name: 'Doe')
          create(:player, user: new_user, game: game, finishing_place: 1)
          game.score_game

          expect(subject).to eq('John Doe')
        end
      end
    end
  end
end
