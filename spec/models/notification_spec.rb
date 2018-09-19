require 'rails_helper'

describe Notification, type: :model do
  context 'relationships' do
    it { should belong_to :recipient }
    it { should belong_to :actor }
    it { should belong_to :notifiable }
  end
  context 'validations'
  context 'methods'
end
