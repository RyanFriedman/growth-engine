FactoryBot.define do
  factory :customer do
    sequence(:email) { |n| "john.doe#{n}@example.com" }
  end

  factory :customer_with_order, class: Customer do
    transient do
      orders_count { 1 }

      after(:create) do |customer, evaluator|
        create_list(:order, evaluator.orders_count, customer: customer)
      end
    end
  end

  factory :order do
    sequence(:title) { |n| "order ##{n}" }
  end
end