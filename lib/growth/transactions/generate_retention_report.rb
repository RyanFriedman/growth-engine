require_relative '../system/container'

module Growth
  module Transactions
    class GenerateRetentionReport
      include Dry::Transaction(container: Growth::System::Container)

      step :validate, with: "growth.operations.retention_report.validate"
      step :prepare, with: "growth.operations.retention_report.prepare"
      step :generate, with: "growth.operations.retention_report.generate"
    end
  end
end