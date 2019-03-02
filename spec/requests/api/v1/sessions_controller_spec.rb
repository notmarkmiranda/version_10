require 'rails_helper'

describe Api::V1::SessionsController, type: :request do
  let(:user) { create(:user, password: 'password') }
  describe 'POST#create' do
    let(:login_url) { '/api/v1/login' }
    let(:params) do
      {
        auth: {
          email: user.email,
          password: 'password'
        }
      }
    end


    describe 'with correct username & password' do
      before do
        expect(Auth).to receive(:issue).with({ user: user.id }).and_return('token!')
        post login_url, params: params
      end

      let(:ex_return) { {"jwt" => "token!"} }

      it 'returns a JWT' do
        expect(JSON.parse(response.body)).to eq(ex_return)
      end
    end
    describe 'with incorrect username & password'
  end
end
