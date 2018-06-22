require 'rails_helper'

RSpec.describe Player, type: :model do
  context 'validations'

  context 'relationships' do
    it { should belong_to :game }
    it { should belong_to :user }
    it { should delegate_method(:full_name).to(:user).with_prefix(true) }
  end

  context 'methods' do
    context '#calculate_score'
    context 'score_player'
    context 'self#rank_by_score'
  end
end
