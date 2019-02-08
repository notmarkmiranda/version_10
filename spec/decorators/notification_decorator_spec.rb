require 'rails_helper'

describe NotificationDecorator, type: :decorator do
  let(:notification) { create(:notification).decorate }
  context '#mark_as_read_link' do
    subject { notification.mark_as_read_link }
    it 'returns nil' do
      notification.update(read_at: Time.now)

      expect(subject).to be_nil
    end

    it 'returns the link' do
      notification.update(read_at: nil)

      expected_return = '| <a href="#">mark as read</a>'
      expect(subject).to eq(expected_return)
    end
  end

  context '#notification_status' do
    subject { notification.notification_status }

    it 'returns the approved half' do
      notification.notifiable.approve!(User.last)

      expect(subject).to eq('approved less than a minute ago')
    end

    it 'returns the non-approved half' do
      notification.notifiable.update(status: 'pending')

      expect(subject).to eq('less than a minute ago')
    end
  end
end
