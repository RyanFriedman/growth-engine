require "pry"

module Growth
  class Engine < ::Rails::Engine
    isolate_namespace Growth 
  end
end