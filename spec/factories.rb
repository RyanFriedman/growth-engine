FactoryBot.define do
  factory :customer do
    sequence(:email) { |n| "john.doe#{n}@example.com" }
  end
end