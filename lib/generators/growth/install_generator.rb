require 'rails/generators/base'
require 'securerandom'

module Growth
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      desc "Creates the growth.rb initializer and adds '/stats' routes to your application."

      def copy_initializer
        template "growth.rb", "config/initializers/growth.rb"
      end
      
      def setup_routes
        route 'mount Growth::Engine, at: "/stats"'
      end
    end
  end
end