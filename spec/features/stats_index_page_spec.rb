require 'rails_helper'

describe 'stats index page' do
  it 'displays total resources count' do
    create_list(:customer, 2)

    visit_stats_page

    Growth.models_to_measure.each do |resource|
      expect(page).to have_header(resource.to_s.pluralize, 'h6')
      expect(page).to have_header(resource.count, 'h2')
    end
  end

  it 'displays sub resources count for main resource' do
    create_list(:customer, 2)

    create(:customer_with_order)
    create(:customer_with_order, orders_count: 2)

    visit_stats_page
    submit_select_form(target_form, 'Orders')

    expect(page).to have_content('Customers that have Orders: 2')
  end

  it 'displays sub resources total count' do
    create(:customer_with_order)
    create(:customer_with_order, orders_count: 2)

    visit_stats_page
    submit_select_form(target_form, 'Orders')

    expect(page).to have_content('Total Orders created: 3')
  end

  it 'displays retention data for given resources' do
    create(:customer)

    create(:customer_with_order, order_created_at: Date.current.beginning_of_month)
    create(:customer_with_order, order_created_at: Date.current.beginning_of_month + 7.days)

    create(:customer_with_order, order_created_at: Date.current.beginning_of_month + 8.days)
    create(:customer_with_order, order_created_at: Date.current.beginning_of_month + 21.days)

    create(:customer_with_order, order_created_at: Date.current.beginning_of_month + 22.days)
    create_list(:customer_with_order, 2, order_created_at: Date.current.end_of_month)

    visit_stats_page
    submit_select_form(target_form, 'Orders')

    expect(page).to have_content('7 Customers have 1 order (100.0% of Customers)')
    expect(page).to have_content('2 of these Customers created their first and last order within 7 days')
    expect(page).to have_content('2 of these Customers created their first and last order between 7 and 21 days')
    expect(page).to have_content('3 of these Customers created their first and last order over 21 days apart (HIGH RETENTION)')
  end

  private

  def target_form
    all(:xpath, "//form[@action='/growth/stats']").last
  end
end