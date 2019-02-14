require 'rails_helper'

describe 'GameUsersController', type: :request do
  describe '#create' do
    let(:game) { create(:game) }
    let(:admin) { game.league.user }
    let(:user_params) { attributes_for(:user).except(:password) }
    subject(:game_user_create) { post game_users_path, params: { user: user_params } }

    before do
      allow_any_instance_of(GameUsersController).to receive(:game_id).and_return(game.id)
    end

    describe 'as an admin' do
      before { stub_current_user(admin) }
      it 'should create a user and a membership' do
        expect {
          game_user_create
        }.to change(User, :count).by(1)
        .and change(Membership, :count).by(1)
        expect(response).to redirect_to game_path game, user_id: User.last.id
      end
    end

    describe 'as a user' do
      it 'should not create a user and a membership' do
        expect {
          game_user_create
        }.to change(User, :count).by(0)
        .and change(Membership, :count).by(0)
        expect(response).to redirect_to root_path
      end
    end
  end
end
