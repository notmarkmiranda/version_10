require 'rails_helper'

RSpec.describe Season, type: :model do
  context 'validations'

  context 'relationships' do
    it { should belong_to :league }
    it { should have_many :games }
    it { should delegate_method(:count).to(:games).with_prefix(true) }
  end

  context 'methods' do
    let(:game)   { create(:game, buy_in: 100) }
    let(:season) { game.season }
    let(:player_1) { double('player_1') }
    let(:player_2) { double('player_2') }
    let(:players) { [player_1, player_2] }

    context '#leader' do
      subject { season.leader }

      it 'returns the player' do
        allow(season.players).to receive(:rank_by_score).with(season).and_return(players)
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

        expect(subject).to match(nil)
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

    context '#ordered_rankings_full_names' do
      subject { season.ordered_rankings_full_names }

      it 'returns an empty array for no one qualifying' do
        expect(subject).to eq([])
      end

      it 'returns standings when the players exist' do
        allow(season).to receive(:standings).and_return(players)
        create(:player, game: game)

        expect(subject).to eq(players)
      end
    end

    context 'self#for_select' do
      let(:league) { create(:league) }

      it 'returns an empty array' do
        expect(Season.for_select(league)).to eq([])
      end

      it 'returns an array for select' do
        expect(Season.for_select(season.league)).to eq([["Season #1", season.id]])
      end
    end

    context 'self#select_except_current' do
      it 'returns an empty array' do
        expect(Season.for_select_except_current(season.league, season.id)).to eq([])
      end

      it 'returns an array for select except the current season' do
        other_season = create(:season, league: season.league)
        expected_return = [["Season ##{season.league.season_number(other_season)}", other_season.id]]
        expect(Season.for_select_except_current(season.league, season.id)).to eq(expected_return)
      end
    end
    context 'self#for_user_select_except_current' do
      it 'returns an empty array' do
        expect(Season.for_user_select_except_current(season.league, season.id)).to eq([["View All Seasons", "all"]])
      end

      it 'returns an array for select except the current season' do
        other_season = create(:season, league: season.league)
        expected_return = [
          [ "Season ##{season.league.season_number(other_season)}", other_season.id ],
          [ "View All Seasons", "all" ]
        ]
        expect(Season.for_user_select_except_current(season.league, season.id)).to eq(expected_return)
      end
    end

    context '#standings' do
      subject { season.standings }
      it 'returns an empty array for no players' do
        expect(subject).to be_nil
      end

      it 'returns an array of players when players exist' do
        allow(season.players).to receive(:rank_by_score).with(season).and_return(players)

        expect(subject).to eq(players)
      end
    end

    context '#total_pot' do
      subject { season.total_pot }

      let(:new_season) { create(:season) }
      it 'returns 0 for a brand new season' do
        expect(new_season.total_pot).to eq(0)
      end

      it 'returns total pot for a season with games' do
        create_list(:player, 2, game: game)
        expect(subject).to eq(202)
      end
    end
  end
end
