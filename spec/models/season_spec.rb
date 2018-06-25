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

    context '#most_second_place_finishes' do
      let!(:player) { create(:player, game: game, finishing_place: 2) }
      subject { season.most_second_place_finishes }

      it 'returns an empty array for none' do
        player.update(finishing_place: 1)

        expect(subject).to match([[], nil])
      end

      it 'returns array of full name and number for 1 player' do
        expect(subject).to match([[player.user.full_name], 1])
      end

      it 'returns array for full name and number for multiple players' do
        game_2 = create(:game, season: season)
        player_2 = create(:player, game: game_2, finishing_place: 2)

        player.user.update(first_name: 'Alan', last_name: 'Alda')
        player_2.user.update(first_name: 'Zenith', last_name: 'TV')

        expect(subject).to match([[player.user.full_name, player_2.user.full_name], 1])
      end
    end

    context '#standings'
    context '#ordered_rankings_full_names'
  end
end
