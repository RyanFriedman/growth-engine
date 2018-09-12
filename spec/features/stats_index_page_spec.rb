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
end