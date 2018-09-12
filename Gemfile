source 'https://rubygems.org'

gemspec

gem 'pg'

group :staging, :production do
  gem 'rack-timeout'
  gem 'sass-rails'
end

group :development, :test do
  gem 'pry-rails'
  gem 'awesome_print'
  gem 'rspec-rails'
  gem 'factory_bot_rails'
end

group :test do
  gem 'poltergeist'
  gem 'database_cleaner'
  gem 'shoulda-matchers'
end