require 'rails_helper'

describe 'stats show page' do
  let(:resource) {'customer'}

  before do
    visit_stats_show_page(resource: resource)
  end

  it 'displays daily resource count'

  it 'displays monthly resource count'

  it 'displays yearly resource count'

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

  it 'shows export to csv links' do
    create(:customer)

    create_list(:customer_with_order, 2)
    create_list(:customer_with_order, 3, orders_count: 2)

    click_link('Order')

    expect(page).to have_link('export emails to csv', href: '/growth/stats/Customer.csv?association=Customer-Order&source_resources_count=2&target_resources_count=1')
    expect(page).to have_link('export emails to csv', href: '/growth/stats/Customer.csv?association=Customer-Order&source_resources_count=3&target_resources_count=2')
  end

  context 'when resource does not have EMAIL attribute' do
    let(:resource) {'product'}

    it 'hides export to csv link' do
      create(:product_with_line_item)

      click_link('LineItem')

      expect(page).to_not have_link('export emails to csv' )
    end
  end
end