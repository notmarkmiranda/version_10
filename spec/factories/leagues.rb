FactoryBot.define do
  factory :league do
    sequence :name { |n| "MyString#{n}" }
    user
    privated false
  end
end
