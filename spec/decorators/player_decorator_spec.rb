require 'rails_helper'

describe PlayerDecorator, type: :decorator do
  let(:player) { create(:player).decorate }
  let(:game) { player.game }

  before { game.complete! }

  context '#additional_expense_text' do
    subject { player.additional_expense_text }

    it 'returns nil' do
      player.update(additional_expense: 0)

      expect(subject).to be_nil
    end

    it 'returns the text' do
      player.update(additional_expense: 1)

      expect(subject).to eq('Rebuy or Add-on: $1')
    end
  end

  context '#name_with_place' do
    subject(:name_with_place) { player.name_with_place }

    context 'when a game is completed' do
      before do
        game.complete!
        player.update(finishing_place: 2)
      end

      it 'returns the player\'s full name with their finishing place' do
        expect(name_with_place).to eq("#{player.finishing_place}. #{player.user_full_name}")
      end
    end

    context 'when a game is not completed' do
      before { game.uncomplete! }

      it 'it returns the player\'s full name' do
        expect(name_with_place).to eq(player.user_full_name)
      end
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

    it 'returns the finished_at time for an incomplete game + finished player' do
      game.uncomplete!
      travel_to Time.zone.local(2015, 5, 9, 17, 30, 00) do
        player.update(finished_at: Time.now)

        expect(subject).to eq('Finished: May 9,  5:30 PM | Rebuy or Add-on: $1')
      end
    end
  end
end
