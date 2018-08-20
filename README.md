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

Next, you need to run the generator:
```bash
$ rails generate growth:install
```

Running the install generator does two things:

1. Mounts the stats engine at 'localhost:3000/stats' by adding to your routes.rb

```ruby
Rails.application.routes.draw do
	mount Growth::Engine, at: "/stats"
end
```

2. Creates an initializer at '/config/initalizers/growth.rb'

```ruby
Growth.models_to_measure = ApplicationRecord.descendants.map { |model| model.to_s }
```

```ruby Growth.models_to_measure ``` takes an array of models as strings, ex. ["Posts", "Users", "Comments"].  The default measures all models.


## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
