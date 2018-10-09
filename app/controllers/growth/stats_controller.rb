require 'csv'

require_dependency "growth/application_controller"
require_dependency "growth/transactions/generate_retention_report"

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
          Growth::Transactions::GenerateRetentionReport.new.call(associations: params['association']) do |m|
            m.success do |result|
              render :show, locals: {resource: resource, report: result[:report]}
            end

            m.failure do |result|
              render :show, locals: {resource: resource, report: result[:report]}
            end
          end
        end

        format.csv do
          source_resources_count = params[:source_resources_count].to_i
          target_resources_count = params[:target_resources_count].to_i

          Growth::Transactions::GenerateRetentionReport.new.call(associations: params['association']) do |m|
            m.success do |result|
              stats = result[:report][:resources_stats].find do |stats|
                stats[:total_source_resources] == source_resources_count
                stats[:total_target_resources] == target_resources_count
              end

              resources = resource.constantize.find(stats[:total_source_resources_ids])

              send_data to_csv(resources), filename: "#{resource.pluralize}-#{Date.today}.csv"
            end

            m.failure do |result|
              raise 'failed to export csv'
            end
          end
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