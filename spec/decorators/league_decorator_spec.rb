require 'rails_helper'

describe LeagueDecorator, type: :decorator do
  let(:league) { create(:league).decorate }
  describe '#game_frequency_text' do
    subject { league.game_frequency_text }
    describe 'no game scheduled' do
      it 'returns Not enough games to measure this yet' do
        expected_return = 'Not enough games to measure this yet.'
        expect(subject).to eq(expected_return)
      end
    end

    describe 'with games scheduled' do
      before do
        season = league.current_season
        travel_to Time.zone.local(2015, 5, 9, 17, 30, 00) do
          create(:game, season: season, date: Date.today, completed: true)
          create(:game, season: season, date: Date.new(2015, 6, 9), completed: true)
        end
      end

      it 'returns the frequency text' do
        expect(subject).to eq('3.43 weeks')
      end
    end
  end
end
