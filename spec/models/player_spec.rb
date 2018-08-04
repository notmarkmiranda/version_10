require 'rails_helper'

RSpec.describe Player, type: :model do
  context 'validations'

  context 'relationships' do
    it { should belong_to :game }
    it { should belong_to :user }
    it { should delegate_method(:full_name).to(:user).with_prefix(true) }
  end

  context 'methods' do
    let(:game)   { create(:game, buy_in: 100) }
    let(:player) { create(:player, game: game) }

    context '#calculate_score' do
      subject { player.calculate_score }

      it 'scores a single player' do
        expect(subject).to eq(4.97)
      end

      it 'scores with 2 players' do
        create(:player, game: game)

        expect(subject).to eq(7.03)
      end
    end

    context '#score_player' do
      subject { player.score_player }

      it 'returns true' do
        allow(player).to receive(:calculate_score).and_return(1.0)

        expect(subject).to be true
        expect(player.reload.score).to eq(1.0)
      end
    end

    context '#season_number' do
      it 'returns the season number' do
        expect(player.season_number).to eq(1)
      end

      let(:new_season) { create(:season, league: game.season.league) }
      let(:new_game) { create(:game, season: new_season) }
      let(:new_player) { create(:player, game: new_game) }
      it 'returns the season number' do
        expect(new_player.season_number).to eq(2)
      end
    end


    context 'self#rank_by_score' do
      let(:season) { game.season }

      it 'returns an nil for no players' do
        expect(Player.rank_by_score(season)).to be_nil
      end

      it 'returns an ordered list of players' do
        p1 = double('player1')
        p2 = double('player2')
        players = [p1, p2]
        allow(Player).to receive(:find_by_sql).and_return(players)
        2.times { |n| create(:player, game: game, finishing_place: n + 1) }

        expect(game.players.rank_by_score(game.season)).to match(players)
      end
    end
  end
end
