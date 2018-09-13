FactoryBot.define do
  factory :customer do
    sequence(:email) { |n| "john.doe#{n}@example.com" }

    factory :customer_with_order do
      transient do
        orders_count { 1 }

        after(:create) do |customer, evaluator|
          create_list(:order, evaluator.orders_count, customer: customer)
        end
      end
    end
  end

  factory :order do
    sequence(:title) { |n| "order ##{n}" }
    association :customer
  end
end