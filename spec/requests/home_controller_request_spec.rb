require 'rails_helper'

describe 'HomeController', type: :request do
  context 'get#index' do
    it 'renders the index template' do
      get root_path

      expect(response.status).to eq(200)
    end
  end
end
