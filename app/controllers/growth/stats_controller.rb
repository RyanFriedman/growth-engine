require_dependency "growth/application_controller"

module Growth
  class StatsController < ApplicationController
    http_basic_authenticate_with name: Growth.username, password: Growth.password

    include StatsHelper

    def index
      @year = get_year

      @model_joined_with_child = get_model_joined_with_child
      @grouped_model_joined_with_child = get_grouped_model_joined_with_child
                  
      @counts = counts(get_grouped_model_joined_with_child)
      
      @parent_model = get_parent_model
      @child_model = get_child_model
            
      @seven_days_or_less, @between_seven_and_twenty, @twenty_one_days_or_more = 0, 0, 0
      
      respond_to do |format|
        format.html
        format.csv { send_data get_parent_model.to_csv, filename: "#{get_parent_model}-#{Date.today}.csv" }
      end
    end

    private

    def get_year
      params[:year].present? ? params[:year] : Date.current.year
    end

    def counts(grouped_models)
      counts = {}
      grouped_models&.count&.each do |key, value|
        counts.has_key?(value) ? counts[value] += 1 : counts[value] = 1
      end

      counts
    end

    def get_model_joined_with_child
      @joined_model ||= get_parent_model&.unscoped&.joins(pluralize_constant(get_child_model).to_sym)
    end

    def get_grouped_model_joined_with_child
      get_model_joined_with_child&.group(:id)&.order("#{pluralize_constant(get_child_model)}.count ASC")
    end

    def get_parent_model
      if params['models']
        params['models'].split("-").first.singularize.capitalize.constantize
      end
    end

    def get_child_model
      if params['models']
        params['models'].split("-").last.singularize.capitalize.constantize
      end
    end
  end
end