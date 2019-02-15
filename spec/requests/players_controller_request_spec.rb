require 'rails_helper'

describe 'PlayersController', type: :request do
  let(:player) { create(:player) }
  let(:game) { player.game }
  let(:admin) { game.league.user }
  let(:membership) { create(:membership, league: game.league) }
  let(:user) { membership.user }

  describe 'POST#create' do
    before do
      allow_any_instance_of(PlayersController).to receive(:game_id).and_return(game.id)
    end

    describe 'as an admin' do
      before do
        stub_current_user(admin)
      end

      it 'should create a player and give them a finished_at time' do
        expect {
          post players_path, params: { commit: 'Score Player', player: { user_id: user.id } }
        }.to change(Player, :count).by(1)
        expect(Player.last.finished_at).not_to be nil
      end
    end

    describe 'as a non-admin' do
      it 'does not create a player' do
        expect {
          post players_path, params: { commit: 'Score Player', player: { user_id: user.id } }
        }.not_to change(Player, :count)
      end
    end
  end
end
