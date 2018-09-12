require 'rails_helper'

RSpec.describe Growth::ApplicationHelper do
  describe '#group_by_year' do
    it 'returns resources grouped by year' do
      create(:customer, created_at: Date.parse('2017-01-01'))

      create(:customer, created_at: Date.parse('2018-01-01'))
      create(:customer, created_at: Date.parse('2018-02-01'))
      create_list(:customer, 2, created_at: Date.parse('2018-08-01'))
      create_list(:customer, 4, created_at: Date.parse('2018-09-01'))

      create(:customer, created_at: Date.parse('2019-01-01'))

      expected_result = {
          1 => {count: 1, growth: '-'}, 2 => {count: 1, growth: '0%'},
          3 => {count: 0, growth: '-100.0%'}, 4 => {count: 0, growth: '0%'},
          5 => {count: 0, growth: '0%'}, 6 => {count: 0, growth: '0%'},
          7 => {count: 0, growth: '0%'}, 8 => {count: 2, growth: '-'},
          9 => {count: 4, growth: '+100.0%'}, 10 => {count: 0, growth: '-100.0%'},
          11 => {count: 0, growth: '0%'}, 12 => {count: 0, growth: '0%'}
      }

      expect(group_resource_by_month(Customer, 2018)).to eql(expected_result)
    end
  end
end