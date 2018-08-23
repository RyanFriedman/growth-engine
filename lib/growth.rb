require "growth/engine"

module Growth    
  mattr_writer :models_to_measure
  
  def self.models_to_measure
    @@models_to_measure ||= ::ApplicationRecord.descendants.map(&:name)
  end
  
  mattr_accessor :model_blacklist
  @@model_blacklist = []
                  
  def self.setup
    yield if block_given?
  end
end