require 'rails_helper'

RSpec.describe League, type: :model do
  context 'validations' do
    it { should validate_presence_of :user }
    it { should validate_presence_of :name }
  end

  context 'relationships' do
    it { should belong_to :user }
  end

  context 'methods'
end
