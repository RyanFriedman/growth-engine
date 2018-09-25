module Growth
  module ApplicationHelper
    def get_grouped_options(resources)
      resources.map do |model|
        [
            model,
            model.reflect_on_all_associations(:has_many).map do |reflection|
              name = reflection.name.to_s.singularize.camelize
              [name, "#{model}-#{name}"]
            end
        ]
      end
    end

    def counts(grouped_models)
      counts = {}
      grouped_models&.count&.each do |key, value|
        counts.has_key?(value) ? counts[value] += 1 : counts[value] = 1
      end

      counts
    end

    def group_resource_by_month(resource, year)
      previous_year = year.to_i - 1
      range = Date.parse("#{previous_year}-12-01")..Date.parse("#{year}-12-31")
      grouped_resource_by_month = resource
                                      .unscoped
                                      .group_by_month(:created_at, range: range)
                                      .count

      grouped_resource_by_month.each do |date, count|
        percentage = get_change_in_percentage(grouped_resource_by_month[date - 1.month].try(:fetch, :count), count)

        grouped_resource_by_month[date] = {
            count: count,
            growth: percentage_to_string(percentage),
            css: growth_css_class(percentage)
        }
      end
    end
    
    def percentage_to_string(percentage)
      return percentage if percentage == '-'
      return '0%' if percentage == 0 
      percentage > 0 ? "+#{percentage}%" : "#{percentage}%"
    end
      
    def growth_css_class(growth)
      return '' if growth == 0 || growth == '-'
      growth > 0 ? 'increase' : 'decrease'
    end
    
    def growth_today(resource)
      resource.constantize.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).count
    end
    
    def growth_month(resource)
      resource.constantize.where(created_at: Date.current.beginning_of_month..Date.current.end_of_month).count
    end
    
    def growth_year_to_date(resource)
      resource.constantize.unscoped.where('extract(year from created_at) = ?', Date.today.year).count
    end

    private

    def get_change_in_percentage(previous_value, current_value)
      return 0 if previous_value == current_value
      return '-' if previous_value.nil? || previous_value == 0

      if current_value > previous_value
        increase = current_value - previous_value
        increase_in_percentage = (increase / previous_value.to_f) * 100
        
        increase_in_percentage.round(2)
      else
        decrease = previous_value - current_value
        decrease_in_percentage = (decrease / previous_value.to_f) * 100
        
        -decrease_in_percentage.round(2)
      end
    end
  end
end