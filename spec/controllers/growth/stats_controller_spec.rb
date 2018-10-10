require 'rails_helper'

describe Growth::StatsController do
  routes { Growth::Engine.routes }

  describe 'GET show' do
    it 'exports emails to CSV' do
      customer = create(:customer, email: 'brandon@gmail.com')

      create_list(:order, 2, customer: customer)

      get :show, params: {id: 'Customer', association: 'Customer-Order', source_resources_count: '1', target_resources_count: '2'}, format: :csv

      expect(response.body).to eql("email\nbrandon@gmail.com\n")
    end
  end
end