require 'rails_helper'

RSpec.describe League, type: :model do
  context 'validations' do
    it { should validate_presence_of :user }
    it { should validate_presence_of :name }
  end

  context 'relationships' do
    it { should belong_to :user }
    it { should have_many :seasons }
    it { should delegate_method(:count).to(:seasons).with_prefix(true) }
  end

  context 'methods'
end
