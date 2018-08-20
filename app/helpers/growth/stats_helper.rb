module Growth
  module StatsHelper
    def increase_in_percentage(new_number, original_number)
      if new_number == original_number
        return "0"
      end

      return "N/A" if original_number <= 0

      if new_number > original_number
        increase = new_number - original_number
        increase_in_percentage = (increase / original_number.to_f) * 100
        "+ #{increase_in_percentage.round(1)}%"
      else
        decrease = original_number - new_number
        decrease_in_percentage = (decrease / original_number.to_f) * 100
        "- #{decrease_in_percentage.round(1)}%"
      end
    end

    def by_month(model, month)
      model.where('extract(month from created_at) = ?', month)
    end

    def by_year(model, year)
      model.where('extract(year from created_at) = ?', year)
    end

    def by_day(model, day)
      model.where('extract(day from created_at) = ?', day)
    end
  end
end
