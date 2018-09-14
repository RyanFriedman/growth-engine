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
        Failure({report: []})
      else
        Success(input)
      end
    end

    def prepare(input)
      begin
        source_resource, target_resource = input[:associations].split('-').map(&:constantize)
        Success({source_resource: source_resource, target_resource: target_resource})
      rescue => e
        Failure({report: [], error: e})
      end
    end

    def generate(input)
      resources = input[:source_resource].unscoped.joins(input[:target_resource].to_s.pluralize.downcase.to_sym)
      grouped_resources = resources.group(:id).order("#{input[:target_resource].to_s.pluralize}.count ASC")
      resources_distinct_count = resources.distinct.count

      report = []

      get_counts(grouped_resources).each do |source_resource_associations_count, source_resources_count|
        seven_days_or_less, between_eight_and_twenty, twenty_one_days_or_more = 0, 0, 0

        grouped_resources.having("count(#{input[:target_resource].to_s.pluralize}.id) = ?", source_resource_associations_count).count.each do |source_resource_id, count|
          source_resource = input[:source_resource].find(source_resource_id)
          source_resource_associations = source_resource.public_send(input[:target_resource].to_s.pluralize.downcase).order(:created_at)

          if source_resource_associations.count > 1
            first_date = source_resource_associations.first.created_at.to_date

            source_resource_associations.each do |association|
              date = association.created_at.to_date

              if (date - first_date).to_i <= SEVEN_DAYS
                seven_days_or_less += INCREMENT_BY_ONE
              elsif (date - first_date).to_i > SEVEN_DAYS && (date - first_date).to_i <= TWENTY_DAYS
                between_eight_and_twenty += INCREMENT_BY_ONE
              else
                twenty_one_days_or_more += INCREMENT_BY_ONE
              end
            end
          else
            seven_days_or_less += INCREMENT_BY_ONE
          end
        end

        report.push(
            {
                total_source_resources_percentage: calculate_percentage(source_resources_count, resources_distinct_count),
                total_source_resources: source_resources_count,
                total_target_resources: source_resource_associations_count,
                first_seven_days_count: seven_days_or_less,
                middle_period_count: between_eight_and_twenty,
                end_period_count: twenty_one_days_or_more
            }
        )
      end

      Success({
          source_resource: input[:source_resource],
          target_resource: input[:target_resource],
          total_associated_resources: resources_distinct_count,
          total_target_resources: input[:target_resource].count,
          resources_stats: report
      })
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
      (number.to_f / total.to_f) * 100
    end
  end
end