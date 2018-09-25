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
end