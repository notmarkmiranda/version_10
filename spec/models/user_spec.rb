require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validations' do
    it { should validate_presence_of :email }
  end

  context 'relationships' do
    it { should have_many :leagues }
    it { should have_many :players }
  end

  context 'methods'
end
