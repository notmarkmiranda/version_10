require 'rails_helper'

describe Notification, type: :model do
  context 'validations'
  context 'relationships' do
    it { should belong_to :recipient }
    it { should belong_to :actor }
    it { should belong_to :notifiable }
  end

  context 'methods' do
    let(:n) { create(:notification) }

    context '#notification_text' do
      subject { n.notification_text }

      it 'returns the text' do
        expect(subject).to eq('Permission was requested!')
      end
    end
  end
end
