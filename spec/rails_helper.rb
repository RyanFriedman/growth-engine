# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../spec/dummy/config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'capybara/poltergeist'
require 'support/factory_bot'
require 'support/features/navigation_helpers'
require 'support/features/page_elements_helpers'
require 'support/features/form_helpers'

require 'factories'

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.include NavigationHelpers, type: :feature
  config.include PageElementsHelpers, type: :feature
  config.include FormHelpers, type: :feature
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :active_record
  end
end

Capybara.javascript_driver = :poltergeist
Capybara.register_driver :poltergeist do |app|
  options = { phantomjs_options: ["--load-images=no"] }
  Capybara::Poltergeist::Driver.new(app, options)
end

Capybara.server = :puma, { Silent: true }