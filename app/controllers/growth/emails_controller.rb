require 'csv'

require_dependency "growth/application_controller"

module Growth
  class EmailsController < ApplicationController
    def new
      render locals: {
          resources_ids: parse_resource_ids
      }
    end

    def create
      redirect_back(fallback_location: root_path, notice: 'You successfully sent emails')
    end

    private

    def parse_resource_ids
      params[:source_resource_ids].join.delete(' ').each_char.map(&:to_i)
    end

    def permitted_params
      params.permit(:from, :subject, :body, :resources_ids)
    end
  end
end