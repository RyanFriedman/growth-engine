source 'https://rubygems.org'

gemspec

gem 'chartkick'

group :staging, :production do
  gem 'rack-timeout'
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
end