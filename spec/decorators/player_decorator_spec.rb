require 'rails_helper'

describe PlayerDecorator, type: :decorator do
  let(:player) { create(:player).decorate }
  context '#additional_expense_text' do
    subject { player.additional_expense_text }

    it 'returns nil' do
      player.update(additional_expense: 0)

      expect(subject).to be_nil
    end

    it 'returns the text' do
      player.update(additional_expense: 1)

      expect(subject).to eq('| Rebuy or Add-on: $1')
    end
  end

  context '#score_text' do
    subject { player.score_text }

    it 'returns the score' do
      player.update(additional_expense: 0)

      expect(subject).to eq('Score: 1.5 ')
    end

    it 'returns the score with the additional text' do
      player.update(additional_expense: 1)

      expect(subject).to eq('Score: 1.5 | Rebuy or Add-on: $1')
    end
  end
end
