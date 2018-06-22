require 'rails_helper'

RSpec.describe Player, type: :model do
  context 'validations' do

  end

  context 'relationships' do
    it { should belong_to :game }
    it { should belong_to :user }
    it { should delegate_method(:full_name).to(:user).with_prefix(true) }
  end

  context 'methods'
end
