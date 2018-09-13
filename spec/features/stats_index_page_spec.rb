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

    target_form = all(:xpath, "//form[@action='/growth/stats']").last

    submit_select_form(target_form, 'Orders')

    expect(page).to have_content('Customers that have Orders: 2')
  end
end