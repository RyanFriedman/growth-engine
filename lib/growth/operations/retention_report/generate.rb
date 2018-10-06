module Growth
  module Operations
    module RetentionReport
      class Generate
        include Dry::Transaction::Operation

        def call(input)
          report = []
          input[:grouped_resources_count].each do |count, source_resources_ids|
            report.push(
                {
                    total_source_resources_percentage: calculate_percentage(source_resources_ids.count, input[:resources_distinct_count]),
                    total_source_resources: source_resources_ids.count,
                    total_target_resources: count,
                    total_source_resources_ids: source_resources_ids.sort
                }
            )
          end

          Success(
              {
                  report: {
                      source_resource: input[:source_resource],
                      target_resource: input[:target_resource],
                      total_associated_resources: input[:resources_distinct_count],
                      total_target_resources: input[:target_resource].count,
                      resources_stats: report
                  }
              }
          )
        end

        private

        def calculate_percentage(number, total)
          ((number.to_f / total.to_f) * 100).round(2)
        end
      end
    end
  end
end

