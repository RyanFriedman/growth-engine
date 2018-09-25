LineItem.destroy_all
Order.destroy_all
Customer.destroy_all
Product.destroy_all

customer_attributes = Array.new(100) do
  name = "#{Faker::Name.first_name} #{Faker::Name.last_name}"
  {
      email: Faker::Internet.safe_email(name)
  }
end

customers = Customer.create!(customer_attributes)

product_attributes = YAML.load_file(Rails.root.join('db/seeds/products.yml'))

product_attributes.each do |attributes|
  Product.create! attributes
end

customers.each do |customer|
  (1..3).to_a.sample.times do
    order = Order.create!(
        customer: customer,
        address_line: Faker::Address.street_address,
        address_city: Faker::Address.city,
        address_state: Faker::Address.state_abbr,
        address_zip: Faker::Address.zip
    )

    item_count = (1..3).to_a.sample
    Product.all.sample(item_count).each do |product|
      LineItem.create!(order: order, product: product)
    end
  end
end