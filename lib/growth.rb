require "growth/engine"

module Growth    
  mattr_accessor :models_to_measure
  # @@models_to_measure = Rails::ApplicationRecord.descendants.collect(&:name)
  
  mattr_accessor :model_blacklist
  @@model_blacklist = []
  
  def self.setup
    yield self
  end
end