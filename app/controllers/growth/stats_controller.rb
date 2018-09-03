require_dependency "growth/application_controller"

module Growth
  class StatsController < ApplicationController
    http_basic_authenticate_with name: Growth.username , password: Growth.password
    
    def index
      @models = Growth.models_to_measure - Growth.model_blacklist
      @year = params[:year].present? ? params[:year] : Date.current.year
    end
  
  end
end