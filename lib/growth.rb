require "growth/engine"

module Growth    
  mattr_accessor :username
  mattr_accessor :password
  mattr_accessor :model_blacklist
  mattr_writer   :models_to_measure

  @@model_blacklist = []

  def self.models_to_measure
    @@models_to_measure ||= ::ActiveRecord::Base.descendants.map(&:name) - ::ActiveRecord::Base.send(:subclasses).map(&:name)
  end
  
  def self.setup
    yield if block_given?
  end
end