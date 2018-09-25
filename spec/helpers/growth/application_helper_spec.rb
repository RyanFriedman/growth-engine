require 'rails_helper'

RSpec.describe Growth::ApplicationHelper do
  describe '#group_by_year' do
    it 'returns resources grouped by year' do
      create(:customer, created_at: Date.parse('2017-12-01'))
      create(:customer, created_at: Date.parse('2017-12-01'))

      create(:customer, created_at: Date.parse('2018-01-01'))
      create(:customer, created_at: Date.parse('2018-02-01'))
      create_list(:customer, 2, created_at: Date.parse('2018-08-01'))
      create_list(:customer, 4, created_at: Date.parse('2018-09-01'))

      create(:customer, created_at: Date.parse('2019-01-01'))

      expected_result = {
          "2017-12-01".to_date => {count: 2, css: '', growth: '-'},
          "2018-01-01".to_date => {count: 1, css: 'decrease', growth: '-50.0%'},
          "2018-02-01".to_date => {count: 1, css: '', growth: '0%'},
          "2018-03-01".to_date => {count: 0, css: 'decrease', growth: '-100.0%'},
          "2018-04-01".to_date => {count: 0, css: '', growth: '0%'},
          "2018-05-01".to_date => {count: 0, css: '', growth: '0%'},
          "2018-06-01".to_date => {count: 0, css: '', growth: '0%'},
          "2018-07-01".to_date => {count: 0, css: '', growth: '0%'},
          "2018-08-01".to_date => {count: 2, css: '', growth: '-'},
          "2018-09-01".to_date => {count: 4, css: 'increase', growth: '+100.0%'},
          "2018-10-01".to_date => {count: 0, css: 'decrease', growth: '-100.0%'},
          "2018-11-01".to_date => {count: 0, css: '', growth: '0%'},
          "2018-12-01".to_date => {count: 0, css: '', growth: '0%'}
      }

      expect(group_resource_by_month(Customer, 2018)).to eql(expected_result)
    end
  end
end