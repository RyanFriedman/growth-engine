require 'csv'

require_dependency "growth/application_controller"

module Growth
  class EmailsController < ApplicationController
    def new
      render :new
    end
  end
end