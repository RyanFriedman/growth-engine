require 'rails_helper'

describe 'stats index page' do
  it 'displays total resources count' do
    create_list(:customer, 2)

    visit_stats_page

    Growth.models_to_measure.each do |resource|
      expect(page).to have_css('p', text: resource.to_s.pluralize)
      expect(page).to have_header(resource.count, 'h4')
    end
  end
end