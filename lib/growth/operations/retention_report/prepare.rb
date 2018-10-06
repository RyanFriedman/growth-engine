module Growth
  module Operations
    module RetentionReport
      class Prepare
        include Dry::Transaction::Operation

        def call(input)
          begin
            source_resource, target_resource = input[:associations].split('-').map(&:constantize)
            Success({source_resource: source_resource, target_resource: target_resource})
          rescue => e
            Failure({report: {resources_stats: []}, error: e})
          end
        end
      end
    end
  end
end

