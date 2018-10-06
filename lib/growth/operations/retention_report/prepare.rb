module Growth
  module Operations
    module RetentionReport
      class Prepare
        include Dry::Transaction::Operation

        def call(input)
          begin
            source_resource, target_resource = input[:associations].split('-').map(&:constantize)
            resources = source_resource.unscoped.joins(target_resource.to_s.pluralize.underscore.to_sym)
            grouped_resources = resources.group(:id).order("#{target_resource.to_s.pluralize.underscore}.count ASC")

            Success({
                source_resource: source_resource,
                target_resource: target_resource,
                grouped_resources_count: invert(grouped_resources.count),
                resources_distinct_count: resources.distinct.count
            })
          rescue => e
            Failure({report: {resources_stats: []}, error: e})
          end
        end

        private

        def invert(hash)
          hash.each_with_object({}) {|(k, v), o| (o[v] ||= []) << k}
        end
      end
    end
  end
end

