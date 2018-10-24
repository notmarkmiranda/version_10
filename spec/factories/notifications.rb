FactoryBot.define do
  factory :notification do |notification|
    association :recipient, factory: :user
    association :actor, factory: :user
    read_at '2018-09-19 09:25:47'
    action 'MyString'
    association :notifiable, factory: :membership
  end
end
