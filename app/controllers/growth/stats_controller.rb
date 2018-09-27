require 'csv'

require_dependency "growth/application_controller"
require_dependency "growth/generate_retention_report"

module Growth
  class StatsController < ApplicationController
    def index
      resources = Growth.models_to_measure

      render :index, locals: {year: get_year, resources: resources}
    end

    def show
      resource = params[:id].camelize

      respond_to do |format|
        format.html do
          Growth::GenerateRetentionReport.new.call(associations: params['association']) do |m|
            m.success do |result|
              render :show, locals: {resource: resource, report: result[:report]}
            end

            m.failure do |result|
              render :show, locals: {resource: resource, report: result[:report]}
            end
          end
        end

        format.csv do
          resources = resource.constantize.find(params[:resources_ids])

          send_data to_csv(resources), filename: "#{resource.pluralize}-#{Date.today}.csv"
        end
      end
    end

    private

    def get_year
      params[:year].present? ? params[:year].to_i : Date.current.year
    end

    def to_csv(resources)
      attributes = %w{email}

      CSV.generate(headers: true) do |csv|
        csv << attributes

        resources.each do |user|
          csv << attributes.map{ |attr| user.send(attr) }
        end
      end
    end
  end
end