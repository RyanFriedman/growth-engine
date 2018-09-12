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

  it 'displays table with months names as header' do
    visit_stats_page

    %w(Title January February March April May June July August September October November December).each do |title|
      expect(page).to have_table_header(title)
    end
  end
end