require 'rails_helper'

RSpec.describe Game, type: :model do
  context 'validations' do
    it { should validate_presence_of :date }
  end

  context 'relationships' do
    it { should belong_to :season }
    xit { should have_many :players }
  end

  context 'methods'
end
