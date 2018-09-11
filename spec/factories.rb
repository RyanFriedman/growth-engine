FactoryBot.define do
  factory :customer do
    sequence(:email) { |n| "john.doe#{n}@example.com" }
  end

  factory :order do
    sequence(:title) { |n| "order ##{n}" }
  end
end