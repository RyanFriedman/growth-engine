require 'rails_helper'

describe 'stats show page' do
  let(:resource) {'customer'}

  before do
    visit_stats_show_page(resource: resource)
  end

  it 'displays daily, monthly, yearly resource count' do
    create_list(:customer, 2)
    create_list(:customer, 3, created_at: Date.current.end_of_month)
    create_list(:customer, 4, created_at: Date.current.end_of_year)

    visit_stats_show_page(resource: resource)

    expect(page).to have_css('h2', text: '2')
    expect(page).to have_css('h2', text: '5')
    expect(page).to have_css('h2', text: '9')
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

  context 'when resource has EMAIL attribute' do
    before do
      create(:customer)

      create_list(:customer_with_order, 2)
      create_list(:customer_with_order, 3, orders_count: 2)

      click_link('Order')
    end

    it 'shows export to csv links' do
      expect(page).to have_link('export emails to csv', href: '/growth/stats/Customer.csv?association=Customer-Order&source_resources_count=2&target_resources_count=1')
      expect(page).to have_link('export emails to csv', href: '/growth/stats/Customer.csv?association=Customer-Order&source_resources_count=3&target_resources_count=2')
    end

    it 'shows submit button', js: true do
      check('2 Customers have 1 order (40.0% of Customers)')
      check('3 Customers have 2 orders (60.0% of Customers)')

      click_on 'Write email'

      within(:xpath, "//form[@action='/growth/emails']") do
        fill_in 'from', with: 'test'
        fill_in 'body', with: 'test'
        fill_in 'subject', with: 'test'

        click_on 'Send emails'
      end

      expect(page).to have_content('You successfully sent emails')
    end
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