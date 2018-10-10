require 'rails_helper'

describe 'customer page' do
  before do
    visit '/growth/stats/customer'
  end

  it 'shows retention report' do
    create_list(:customer, 2)

    create(:customer_with_order)
    create(:customer_with_order, orders_count: 2)

    click_link('Order')

    expect(page).to have_content('Customers that have Orders: 2')
  end

  it 'displays sub resources total count' do
    create(:customer_with_order)
    create(:customer_with_order, orders_count: 2)

    click_link('Order')

    expect(page).to have_content('Total Orders created: 3')
  end

  it 'displays retention data for given resources' do
    create(:customer)

    create_list(:customer_with_order, 2)
    create_list(:customer_with_order, 3, orders_count: 2)

    click_link('Order')

    expect(page).to have_content('2 Customers have 1 order (40.0% of Customers)')
    expect(page).to have_content('3 Customers have 2 orders (60.0% of Customers)')
  end
end