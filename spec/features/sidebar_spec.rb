require 'rails_helper'

describe 'stats index page' do
  it 'displays models list' do
    visit '/growth'

    within('.sidebar-sticky') do
      Growth.models_to_measure.each do |resource|
        expect(page).to have_css('li', text: resource)
      end
    end
  end

  it 'links to customer page' do
    visit '/growth'
    click_link('Customers')

    expect(current_path).to eql('/growth/stats/customer')
  end

  it 'links to product page' do
    visit '/growth'
    click_link('Products')

    expect(current_path).to eql('/growth/stats/product')
  end

  it 'links to order page' do
    visit '/growth'
    click_link('Orders')

    expect(current_path).to eql('/growth/stats/order')
  end

  it 'links to payment page' do
    visit '/growth'
    click_link('Payments')

    expect(current_path).to eql('/growth/stats/payment')
  end

  it 'links to line items page' do
    visit '/growth'
    click_link('LineItems')

    expect(current_path).to eql('/growth/stats/lineItem')
  end
end