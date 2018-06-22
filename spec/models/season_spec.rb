require 'rails_helper'

RSpec.describe Season, type: :model do
  context 'validations'

  context 'relationships' do
    it { should belong_to :league }
    it { should have_many :games }
    it { should delegate_method(:count).to(:games).with_prefix(true) }
  end

  context 'methods' do
    let(:game)   { create(:game) }
    let(:season) { game.season }

    context '#leader' do
      subject { season.leader }
      let(:player_1) { double('player_1') }
      let(:player_2) { double('player_2') }
      let(:players) { [player_1, player_2] }

      it 'returns the player' do
        allow(season).to receive(:player_rankings).and_return(players)
        expect(subject).to eq(player_1)
      end
    end

    context '#leader_full_name' do
      let(:player) { create(:player, game: game) }
      subject { season.leader_full_name }

      it 'returns a full_name' do
        allow(season).to receive(:leader).and_return(player)
        player.user.update(first_name: 'Mark', last_name: 'Miranda')

        expect(subject).to eq('Mark Miranda')
      end
    end
  end
end
