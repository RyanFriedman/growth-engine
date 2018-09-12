require_dependency "growth/application_controller"

module Growth
  class StatsController < ApplicationController
    def index
      @joined_model = get_parent_model&.unscoped&.joins(pluralize_constant(get_child_model).to_sym)
      @grouped_joined_model = grouped_joined_model

      @parent = get_parent_model
      @child = get_child_model

      @seven_days_or_less, @between_seven_and_twenty, @twenty_one_days_or_more = 0, 0, 0

      respond_to do |format|
        format.html do
          render :index, locals: {
              year: get_year,
              resources: Growth.models_to_measure,
          }
        end

        format.csv { send_data get_parent_model.to_csv, filename: "#{get_parent_model}-#{Date.today}.csv" }
      end
    end

    private

    def get_parent_joined_with_child
      @joined_model ||= get_parent_model&.unscoped&.joins(pluralize_constant(get_child_model).to_sym)
    end

    def grouped_joined_model
      get_parent_joined_with_child&.group(:id)&.order("#{pluralize_constant(get_child_model)}.count ASC")
    end

    def get_parent_model
      if params['models'].present?
        params['models'].split("-").first.singularize.camelize.constantize
      end
    end

    def get_child_model
      if params['models'].present?
        params['models'].split("-").last.singularize.camelize.constantize
      end
    end

    def get_year
      params[:year].present? ? params[:year] : Date.current.year
    end
  end
end