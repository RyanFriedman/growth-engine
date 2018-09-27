require 'rails_helper'

describe Growth::StatsController do
  routes { Growth::Engine.routes }

  describe 'GET show' do
    it 'exports emails to CSV' do
      create(:customer)
      brandon = create(:customer, email: 'brandon@gmail.com')
      ryan = create(:customer, email: 'ryan@gmail.com')

      get :show, params: {id: 'Customer', resources_ids: [brandon.id, ryan.id]}, format: :csv

      expect(response.body).to eql("email\nryan@gmail.com\nbrandon@gmail.com\n")
    end
  end
end