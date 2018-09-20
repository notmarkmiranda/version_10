require 'rails_helper'

describe Notification, type: :model do
  context 'relationships' do
    it { should belong_to :recipient }
    it { should belong_to :actor }
    it { should belong_to :notifiable }
  end
  context 'validations'
  context 'methods' do
    context 'scope#unread' do
      let(:notification) { create(:notification, read_at: nil) }

      it 'returns only unread notifications' do
        read_notification = create(:notification, read_at: DateTime.now)

        expect(Notification.unread).to include(notification)
        expect(Notification.unread).to_not include(read_notification)
      end
    end
  end
end
