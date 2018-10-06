require "dry/transaction/operation"

require_relative '../operations/retention_report/validate'
require_relative '../operations/retention_report/prepare'
require_relative '../operations/retention_report/generate'

module Growth
  module System
    class Container
      extend Dry::Container::Mixin

      namespace "growth" do
        namespace "operations" do
          namespace "retention_report" do
            register "validate" do
              Growth::Operations::RetentionReport::Validate.new
            end

            register "prepare" do
              Growth::Operations::RetentionReport::Prepare.new
            end

            register "generate" do
              Growth::Operations::RetentionReport::Generate.new
            end
          end
        end
      end
    end
  end
end