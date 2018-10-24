require 'rails_helper'

describe LeaguePolicy, type: :policy do
  let(:league) { create(:league) }
  let(:user) { league.user }
  subject { described_class.new(user, league) }

  describe '#initialize' do
    it 'stores information' do
      expect(subject.user).to eq(user)
      expect(subject.league).to eq(league)
    end
  end

  describe '#show?' do
    it 'returns true' do
      allow(league).to receive(:privated?).and_return(false)
      allow(subject).to receive(:send).with('user_is_allowed?').and_return(true)
      expect(subject.show?).to be true
    end
  end
end
