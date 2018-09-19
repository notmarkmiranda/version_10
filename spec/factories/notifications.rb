FactoryBot.define do
  factory :notification do |notification|
    association :recipient, factory: :user
    association :actor, factory: :user
    action "Membership"
    notification.notifiable { |n| n.association(:membership) }
  end
end
