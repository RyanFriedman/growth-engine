require_dependency "growth/application_controller"

module Growth
  class StatsController < ApplicationController
    def index
      @models = Growth.models_to_measure
      @year = params[:year].present? ? params[:year] : Date.current.year
    end
  end
end