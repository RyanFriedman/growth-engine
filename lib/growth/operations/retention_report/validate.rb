module Growth
  module Operations
    module RetentionReport
      class Validate
        include Dry::Transaction::Operation

        def call(input)
          if input[:associations].blank?
            Failure({report: {resources_stats: []}})
          else
            Success(input)
          end
        end
      end
    end
  end
end

