# Grower
Measure growth in your Rails models through charts and informational tables and custom views.

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'growth'
```

And then execute:
```bash
$ bundle install
```

Next, you need to run the install generator:
```bash
$ rails generate growth:install
```

Running the install generator does two things:

1. Mounts the stats engine at '/stats' by adding to your routes.rb

```ruby
Rails.application.routes.draw do
  mount Growth::Engine, at: "/stats"
end
```

2. Creates an initializer at '/config/initalizers/growth.rb'

```ruby
Growth.models_to_measure = ApplicationRecord.descendants.map { |model| model.to_s }
```

```Growth.models_to_measure ``` takes an array of models as strings, ex. ["Posts", "Users", "Comments"], that you'd like to measure.  The default measures all models.

```Growth.model_blacklist``` takes an array of models as strings, ex. ["AdminUsers"], that you want to prevent the gem from measuring.

```Growth.username ``` is your username for http_basic_auth
```Growth.password``` is your password for http_basic_auth


## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
