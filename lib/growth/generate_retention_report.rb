module Growth
  class GenerateRetentionReport
    include Dry::Transaction

    INCREMENT_BY_ONE = 1
    SEVEN_DAYS = 7
    TWENTY_DAYS = 20

    step :validate
    step :prepare
    step :generate

    private

    def validate(input)
      if input[:associations].blank?
        Failure({report: {resources_stats: []}})
      else
        Success(input)
      end
    end

    def prepare(input)
      begin
        source_resource, target_resource = input[:associations].split('-').map(&:constantize)
        Success({source_resource: source_resource, target_resource: target_resource})
      rescue => e
        Failure({report: {resources_stats: []}, error: e})
      end
    end

    def generate(input)
      resources = input[:source_resource].unscoped.joins(input[:target_resource].to_s.pluralize.downcase.to_sym)
      grouped_resources = resources.group(:id).order("#{input[:target_resource].to_s.pluralize}.count ASC")
      resources_distinct_count = resources.distinct.count

      report = []

      get_counts(grouped_resources).each do |source_resource_associations_count, source_resources_count|
        report.push(
            {
                total_source_resources_percentage: calculate_percentage(source_resources_count, resources_distinct_count),
                total_source_resources: source_resources_count,
                total_target_resources: source_resource_associations_count
            }
        )
      end

      Success(
          {
              report: {
                  source_resource: input[:source_resource],
                  target_resource: input[:target_resource],
                  total_associated_resources: resources_distinct_count,
                  total_target_resources: input[:target_resource].count,
                  resources_stats: report
              }
          }
      )
    end

    private

    def get_counts(grouped_resources)
      counts = {}
      grouped_resources.count.each do |resource_id, count|
        counts.has_key?(count) ? counts[count] += 1 : counts[count] = 1
      end
      counts
    end

    def calculate_percentage(number, total)
      ((number.to_f / total.to_f) * 100).round(2)
    end
  end
end