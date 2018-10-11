$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "growth/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "growth"
  s.version     = Growth::VERSION
  s.authors     = ["Ryan Friedman"]
  s.email       = ["ryan@soundtribe.com"]
  s.homepage    = "http://vibrantlight.co"
  s.summary     = "A beautiful dashboard displaying the monthly and yearly growth of your Rails models."
  s.description = "A beautiful dashboard displaying the monthly and yearly growth of your Rails models."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.0"
  s.add_dependency("dry-container")
  s.add_dependency("dry-transaction")
  s.add_dependency("groupdate")

  s.add_development_dependency "sqlite3"
end
