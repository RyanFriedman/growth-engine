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

    def group_resource_by_month(resource, year)
      from, to = Date.parse("#{year.to_i - 1}-12-01"), Date.parse("#{year}-12-31")
      grouped_resource_by_month = resource
                                      .unscoped
                                      .group_by_month(:created_at, range: from..to)
                                      .count

      map_grouped_resource(grouped_resource_by_month, 1.month)
    end

    def group_resource_by_year(resource, resources)
      from = Date.parse("#{years_since_first_resource(resources).first}-01-01")
      to = Date.parse("#{years_since_first_resource(resources).last}-12-31")

      grouped_resource_by_year = resource.unscoped.group_by_year(:created_at, range: from..to).count
      map_grouped_resource(grouped_resource_by_year, 1.year)
    end

    def growth_today(resource)
      resource.constantize.where(created_at: Time.current.beginning_of_day..Time.current.end_of_day).count
    end
    
    def growth_month(resource)
      resource.constantize.where(created_at: Date.current.beginning_of_month..Date.current.end_of_month).count
    end
    
    def growth_year_to_date(resource)
      resource.constantize.unscoped.where('extract(year from created_at) = ?', Date.current.year).count
    end

    def years_since_first_resource(resources)
      return @years if defined? @years

      mapped_resources = resources.map do |resource|
        resource.unscoped.order(:created_at).first
      end.compact.map(&:created_at).sort

      @years = mapped_resources.empty? ? [Date.current.year] : (mapped_resources.first.to_date.year..Date.current.year).to_a
    end
    
    def pluralize_constant(count = nil, constant)
      return constant.to_s.pluralize if count == nil
      pluralize(count, constant.to_s)
    end

    def flash_message
      if flash[:notice]
        content_tag(:div, flash[:notice], class: 'alert alert-primary')
      end
    end

    private

    def percentage_to_string(percentage)
      return percentage if percentage == '-'
      return '0%' if percentage == 0
      percentage > 0 ? "+#{percentage}%" : "#{percentage}%"
    end

    def growth_css_class(growth)
      return '' if growth == 0 || growth == '-'
      growth > 0 ? 'increase' : 'decrease'
    end

    def map_grouped_resource(grouped_resource, interval)
      grouped_resource.each do |date, count|
        percentage = get_change_in_percentage(grouped_resource[date - interval].try(:fetch, :count), count)

        grouped_resource[date] = {
            count: count,
            growth: percentage_to_string(percentage),
            css: growth_css_class(percentage)
        }
      end
    end

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