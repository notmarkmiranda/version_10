require 'rails_helper'

RSpec.describe Game, type: :model do
  describe 'validations' do
    it { should validate_presence_of :date }
  end

  describe 'relationships' do
    it { should belong_to :season }
    it { should have_many :players }
  end

  describe 'methods' do
    let(:game) { create(:game, date: Date.new(2015, 5, 9), buy_in: 15) }
    describe '#available_players' do
      let(:league) { game.league }
      let(:memberships) { create_list(:membership, 3, league: league) }
      let(:excluded_user) { memberships.last.user }
      let(:excluded_user_collected) { [excluded_user.full_name, excluded_user.id] }

      subject { game.available_players }

      describe 'returns all players that are not finished' do
        before do
          create(:player, game: game, user: excluded_user, finished_at: Time.now)
        end

        it 'excludes a finished player' do
          expect(subject).not_to include(excluded_user_collected)
        end
      end

      describe 'returns players that are do not have an additional expense' do
        before do
          create(:player, game: game, user: excluded_user, additional_expense: 100)
        end

        it 'excludes a player with an additional_expense' do
          expect(subject).not_to include(excluded_user_collected)
        end
      end
    end

    describe '#formatted_date' do
      subject { game.formatted_date }

      it 'returns the formatted truncated date' do
        expect(subject).to eq('May 2015')
      end
    end

    describe '#formatted_full_date' do
      subject { game.formatted_full_date }

      it 'returns the full formatted date' do
        expect(subject).to eq('May 9, 2015')
      end
    end

    describe '#in_the_future?' do
      subject { game.in_the_future? }

      it 'returns true - in the future' do
        game.update(date: Date.tomorrow, completed: true)

        expect(subject).to be true
      end

      it 'returns true - incomplete' do
        game.update(date: Date.yesterday, completed: false)

        expect(subject).to be true
      end

      it 'returns false' do
        game.update(date: Date.yesterday, completed: true)

        expect(subject).to be false
      end
    end

    describe '#player_in_place_full_name' do
      let(:user) { create(:user, first_name: 'Mark', last_name: 'Miranda') }
      let!(:player) { create(:player, user: user, game: game, finishing_place: 3) }

      it 'returns the full name of a player' do
        expect(game.player_in_place_full_name(3)).to eq('Mark Miranda')
      end

      let(:new_game) { create(:game) }
      it 'returns nil for no players' do
        expect(new_game.player_in_place_full_name(3)).to be_nil
      end

      it 'returns nil for no player in place' do
        expect(game.player_in_place_full_name(5)).to be_nil
      end
    end

    describe '#score_game' do
      subject { game.score_game }

      it 'returns because players is empty' do
        expect(game.players).to receive(:empty?).and_return(true)
        response = subject

        expect(response).to be_nil
      end

      it 'scores the game' do
        allow(game.players).to receive(:empty?).and_return(false)
        2.times do |x|
          create(:player, game: game, finishing_place: (x + 1))
        end

        expect(subject).to eq([game.players[0], game.players[1]])
      end
    end

    describe '#total_pot' do
      subject { game.total_pot }

      it 'returns 0 with no pot' do
        expect(subject).to eq 0
      end

      it 'returns a pot with players without additional expense' do
        create_list(:player, 10, game: game, additional_expense: 0)

        expect(subject).to eq 150
      end

      it 'returns a pot with players with additional expense' do
        create_list(:player, 10, game: game, additional_expense: 10)

        expect(subject).to eq 250
      end
    end

    describe '#winner_full_name' do
      it 'returns the winners full name' do
        expect(game).to receive(:player_in_place_full_name).with(1)

        game.winner_full_name
      end
    end

    describe '#season_league_season_number' do

      it 'calls league#season_number' do
        expect(game.league).to receive(:season_number).with(game.season)

        game.season_league_season_number
      end
    end
  end
end
