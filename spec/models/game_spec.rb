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
    let(:game) { create(:game, date: Date.new(2015, 5, 9)) }
    context '#formatted_date' do
      subject { game.formatted_date }
      it 'returns the formatted truncated date' do
        expect(subject).to eq('May 2015')
      end
    end
  end
end
