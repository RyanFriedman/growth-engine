require_dependency "growth/application_controller"
require_dependency "growth/generate_retention_report"

module Growth
  class StatsController < ApplicationController
    
    def index
      resources = Growth.models_to_measure

      Growth::GenerateRetentionReport.new.call(associations: params['association-select']) do |m|
        m.success do |result|
          render :index, locals: {year: get_year, resources: resources, report: result[:report]}
        end

        m.failure do |result|
          render :index, locals: {year: get_year, resources: resources, report: result[:report]}
        end
      end
    end

    def show
      resource = params[:id].camelize
                                              
      Growth::GenerateRetentionReport.new.call(associations: params['association']) do |m|
        m.success do |result|
          render :show, locals: {resource: resource, report: result[:report]}
        end

        m.failure do |result|
          render :show, locals: {resource: resource, report: result[:report]}
        end
      end
    end

    private

    def get_year
      params[:year].present? ? params[:year].to_i : Date.current.year
    end
  end
end