FactoryBot.define do
  factory :customer do
    sequence(:email) { |n| "john.doe#{n}@example.com" }

    factory :customer_with_order do
      transient do
        orders_count { 1 }
        order_created_at { Date.current }

        after(:create) do |customer, evaluator|
          create_list(:order, evaluator.orders_count, customer: customer, created_at: evaluator.order_created_at)
        end
      end
    end
  end

  factory :product do
    sequence(:title) { |n| "product ##{n}" }

    factory :product_with_line_item do
      transient do
        line_items_count { 1 }
        line_item_created_at { Date.current }

        after(:create) do |product, evaluator|
          create_list(:line_item, evaluator.line_items_count, product: product, created_at: evaluator.line_item_created_at)
        end
      end
    end
  end

  factory :order do
    sequence(:address_line) { |n| "Address line ##{n}" }
    sequence(:address_city) { |n| "Address city ##{n}" }
    sequence(:address_state) { |n| "Address state ##{n}" }
    sequence(:address_zip) { |n| "Address zip ##{n}" }
    association :customer
  end

  factory :line_item do
    association :product
    association :order
  end
end