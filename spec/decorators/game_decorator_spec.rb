require 'rails_helper'

describe GameDecorator, type: :decorator do
  let(:game) { create(:game).decorate }

  before do
    stub_current_user(user)
  end

  context '#complete_or_uncomplete_buttons' do
    let(:user) { game.league.user }
    context 'completed game' do
      before { game.update(completed: true) }

      it 'returns an uncomplete button' do
        expected_return = "<form class=\"button_to\" method=\"post\" action=\"/games/#{game.id}/uncomplete\"><input class=\"btn btn-outline-info btn-sm mb-2\" type=\"submit\" value=\"Uncomplete Game\" /></form>"
        expect(game.complete_or_uncomplete_buttons).to eq(expected_return)
      end
    end

    context 'uncomplete game' do
      before { game.update(completed: false) }

      it 'returns a complete button' do
        expected_return = "<form class=\"button_to\" method=\"post\" action=\"/games/#{game.id}/complete\"><input class=\"btn btn-outline-danger btn-sm mb-2\" disabled=\"disabled\" type=\"submit\" value=\"Complete Game\" /></form>"
        expect(game.complete_or_uncomplete_buttons).to eq(expected_return)
      end
    end
  end

  context '#new_player_form' do
    subject { game.new_player_form }

    context 'game not completed' do
      let(:user) { game.league.user }
      before { game.complete! }

      it 'returns nil' do
        expect(subject).to be nil
      end
    end

    context 'user is not admin' do
      let(:user) { create(:membership, league: game.league).user }
      before { game.uncomplete! }

      it 'returns nil' do
        expect(subject).to be nil
      end
    end

    context 'game is completed and user is admin' do
      let(:user) { game.league.user }
      before { game.uncomplete! }

      it 'returns a partial' do
        expect(helper).to receive(:render).with(partial: 'player_form')
        
        subject
      end
    end
  end
end
