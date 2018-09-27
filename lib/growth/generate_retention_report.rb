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
      resources = input[:source_resource].unscoped.joins(input[:target_resource].to_s.pluralize.underscore.to_sym)
      grouped_resources = resources.group(:id).order("#{input[:target_resource].to_s.pluralize.underscore}.count ASC")
      resources_distinct_count = resources.distinct.count

      report = []

      invert(grouped_resources.count).each do |count, source_resources_ids|
        report.push(
            {
                total_source_resources_percentage: calculate_percentage(source_resources_ids.count, resources_distinct_count),
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
                  total_associated_resources: resources_distinct_count,
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

    def invert(hash)
      hash.each_with_object({}){|(k,v),o|(o[v]||=[])<<k}
    end
  end
end