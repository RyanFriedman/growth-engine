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
      default_values = {}
      (1..12).each {|i| default_values[i.to_f] = 0}

      grouped_resource_by_month = resource
                                      .where('extract(year from created_at) = ?', year)
                                      .group("date_part('month', created_at)")
                                      .count

      result = default_values.merge(grouped_resource_by_month)

      result.map do |month, count|
        [month.to_i, {count: count, growth: get_change_in_percentage(result[month - 1], count)}]
      end.to_h
    end

    private

    def get_change_in_percentage(previous_value, current_value)
      return "0%" if previous_value == current_value
      return '-' if previous_value.nil? || previous_value == 0

      if current_value > previous_value
        increase = current_value - previous_value
        increase_in_percentage = (increase / previous_value.to_f) * 100
        "+#{increase_in_percentage.round(2)}%"
      else
        decrease = previous_value - current_value
        decrease_in_percentage = (decrease / previous_value.to_f) * 100
        "-#{decrease_in_percentage.round(2)}%"
      end
    end
  end
end