require 'rails_helper'

RSpec.describe Game, type: :model do
  context 'validations' do
    it { should validate_presence_of :date }
  end

  context 'relationships' do
    it { should belong_to :season }
    it { should have_many :players }
  end

  context 'methods' do
    let(:game) { create(:game, date: Date.new(2015, 5, 9), buy_in: 15) }
    context '#formatted_date' do
      subject { game.formatted_date }

      it 'returns the formatted truncated date' do
        expect(subject).to eq('May 2015')
      end
    end

    context '#formatted_full_date' do
      subject { game.formatted_full_date }

      it 'returns the full formatted date' do
        expect(subject).to eq('May 9, 2015')
      end
    end

    context '#player_in_place_full_name' do
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

    context '#score_game' do
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

    context '#total_pot' do
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

    context '#winner_full_name' do
      it 'returns the winners full name' do
        expect(game).to receive(:player_in_place_full_name).with(1)

        game.winner_full_name
      end
    end

    context '#season_league_season_number' do

      it 'calls league#season_number' do
        expect(game.league).to receive(:season_number).with(game.season)

        game.season_league_season_number
      end
    end
  end
end
