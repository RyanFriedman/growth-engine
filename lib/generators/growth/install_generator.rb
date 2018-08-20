require 'rails/generators/base'
require 'securerandom'

module Growth
  module Generators
    MissingORMError = Class.new(Thor::Error)

    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      desc "Creates a Growth initializer and copy locale files to your application."

      def copy_initializer
        template "growth.rb", "config/initializers/growth.rb"
      end

    end
  end
end