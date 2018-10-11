# GrowthEngine
Measure the yearly and monthly growth of your Rails models with a dashboard mounted on your Rails app.  Specify the models you'd like to measure in a single initializer file and that's it, the gem will handle the rest.

A more advanced feature in the gem allows you to better understand the associations between your models.  For example, let's say you have a Users model that has_many Posts.  Over time you might wonder, how many users have only created one post?  Which user has created the most posts?  Rather than write these database queries each time, the growth gem will automatically generate these reports for you.

## Installation
Add the following line to your Gemfile:
```ruby
gem 'growth'
```

Then run:
```bash
$ bundle install
```

Next, you need to run the generator:
```bash
$ rails generate growth:install
```

Running the install generator does two things:

1. Mounts the stats engine at '/growth' by adding to your routes.rb.  You can also pass a route of your choice to the 'at' param.

```ruby
Rails.application.routes.draw do
  mount Growth::Engine, at: "/growth"
end
```

2. Creates an initializer at '/config/initalizers/growth.rb'

```ruby
Growth.models_to_measure = ApplicationRecord.descendants.map { |model| model.to_s }
```

You can customize the models you'd like to measure by passing an array of models, i.e.:

```ruby
Growth.models_to_measure = [ Users, Posts, Comments ]
```

Options in your config file are:

```Growth.models_to_measure``` takes an array of models, ex. [Posts, Users, Comments], that you'd like to measure.  The default measures all models.

```Growth.model_blacklist``` takes an array of models, ex. [AdminUsers], that you want to prevent the gem from measuring.

```Growth.username ``` is your username for http_basic_auth

```Growth.password``` is your password for http_basic_auth

## License
Please see <a href="https://github.com/VibrantLight/growth/blob/master/LICENSE">LICENSE</a> for licensing details.