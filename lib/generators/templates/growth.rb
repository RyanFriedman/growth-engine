# Measures all models.
# models_to_measure takes an array of Rails models as strings
Growth.models_to_measure = ApplicationRecord.descendants.map { |model| model.to_s }