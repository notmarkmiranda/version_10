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
  end
end
