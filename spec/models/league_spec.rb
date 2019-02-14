require 'rails_helper'

RSpec.describe League, type: :model do
  describe 'validations' do
    it { should validate_presence_of :user }
    it { should validate_presence_of :name }
  end

  describe 'relationships' do
    it { should belong_to :user }
    it { should have_many :seasons }
    it { should have_many :players }
    it { should have_many :memberships }
    it { should delegate_method(:count).to(:seasons).with_prefix(true) }
    it { should delegate_method(:count).to(:players).with_prefix(true) }
  end

  describe 'methods' do
    let(:league) { create(:league) }
    let!(:first_season) { league.current_season }
    let!(:second_season) { create(:season, league: league, active: true) }

    describe '#average_players_per_game' do
      subject { league.average_players_per_game }
      it 'returns 0.0 for no games' do
        expect(subject).to eq(0.0)
      end

      it 'returns the average number of players' do
        games = create_list(:game, 4, season: first_season, completed: true)
        create_list(:player, 9, game: games[1])

        expect(subject).to eq(2.25)
      end
    end

    describe '#current_season' do
      subject { league.current_season }

      it 'returns the active season' do
        expect(subject).to eq(first_season)
      end
    end

    describe '#current_season_number' do
      subject { league.current_season_number }

      it 'returns nil if there are no seasons' do
        league.seasons.destroy_all
        expect(subject).to eq(nil)
      end

      it 'returns the season index' do
        expect(subject).to eq(1)
      end
    end

    describe '#game_every_x_weeks' do
      subject { league.games_every_x_weeks }

      it 'returns Nothing for no games' do
        expect(subject).to be_nil
      end

      it 'returns Nothing for one game' do
        first_season.games.create!(date: Date.new(2015, 5, 9))

        expect(subject).to be_nil
      end

      it 'returns a float' do
        allow(league).to receive(:weeks).and_return(4.5)
        allow(league).to receive(:games_count).and_return(2)
        expect(subject).to eq(3.5)
      end
    end
  end
end
