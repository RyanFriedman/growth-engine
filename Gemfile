source 'https://rubygems.org'

gemspec

gem 'dry-transaction'
gem 'dry-container'
gem 'groupdate'
gem 'jquery-rails'
gem 'puma'
gem 'pg'

group :staging, :production do
  gem 'rack-timeout'
end

group :development, :test do
  gem 'pry-rails'
  gem 'awesome_print'
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'faker'
end

group :test do
  gem 'poltergeist'
  gem 'database_cleaner'
  gem 'shoulda-matchers'
end