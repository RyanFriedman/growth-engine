require 'rails_helper'

RSpec.describe Growth::ApplicationHelper do
  describe '#group_by_year' do
    it 'returns resources grouped by month' do
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

    context 'when no resource created' do
      it do
        expected_result = {
            "2017-12-01".to_date => {count: 0, css: '', growth: '-'},
            "2018-01-01".to_date => {count: 0, css: '', growth: '0%'},
            "2018-02-01".to_date => {count: 0, css: '', growth: '0%'},
            "2018-03-01".to_date => {count: 0, css: '', growth: '0%'},
            "2018-04-01".to_date => {count: 0, css: '', growth: '0%'},
            "2018-05-01".to_date => {count: 0, css: '', growth: '0%'},
            "2018-06-01".to_date => {count: 0, css: '', growth: '0%'},
            "2018-07-01".to_date => {count: 0, css: '', growth: '0%'},
            "2018-08-01".to_date => {count: 0, css: '', growth: '0%'},
            "2018-09-01".to_date => {count: 0, css: '', growth: '0%'},
            "2018-10-01".to_date => {count: 0, css: '', growth: '0%'},
            "2018-11-01".to_date => {count: 0, css: '', growth: '0%'},
            "2018-12-01".to_date => {count: 0, css: '', growth: '0%'}
        }

        expect(group_resource_by_month(Customer, 2018)).to eql(expected_result)
      end
    end
  end

  describe('#group_resource_by_year') do
    it 'returns resources grouped by year' do
      create(:order, created_at: Date.parse("#{1.year.ago.year}-01-01"))
      create(:order, created_at: Date.parse("#{1.year.ago.year}-01-01"))

      create(:order, created_at: Date.parse("#{2.years.ago.year}-01-01"))

      create(:customer, created_at: Date.parse("#{4.year.ago.year}-01-01"))

      expected_result = {
          "#{4.years.ago.year}-01-01".to_date => {count: 0, growth: '-', css: ''},
          "#{3.years.ago.year}-01-01".to_date => {count: 0, growth: '0%', css: ''},
          "#{2.years.ago.year}-01-01".to_date => {count: 1, growth: '-', css: ''},
          "#{1.year.ago.year}-01-01".to_date => {count: 2, growth: '+100.0%', css: 'increase'},
          "#{Date.current.year}-01-01".to_date => {count: 0, growth: '-100.0%', css: 'decrease'}
      }

      expect(group_resource_by_year(Order, [Order, Customer, LineItem])).to eql(expected_result)
    end

    context 'when no resources created' do
      it 'returns for data for current year' do
        expected_result = {
            "#{Date.current.year}-01-01".to_date => {count: 0, growth: '-', css: ''}
        }

        expect(group_resource_by_year(Order, [Order, Customer, LineItem])).to eql(expected_result)
      end
    end
  end

  describe '#years_since_first_resource' do
    it 'returns array of years' do
      create(:order, created_at: Date.parse('2016-01-01'))
      create(:order, created_at: Date.parse('2017-01-01'))

      create(:customer, created_at: Date.parse('2017-01-01'))
      create(:customer, created_at: Date.parse('2011-01-01'))

      create(:product, created_at: Date.parse('2013-01-01'))

      expected_result = (2011..Date.current.year).to_a

      expect(years_since_first_resource([Order, Product, Customer, LineItem])).to eql(expected_result)
    end

    context 'when resources have no records' do
      it 'returns empty array' do
        expect(years_since_first_resource([Order, Product])).to eql([Date.current.year])
      end
    end
  end
end