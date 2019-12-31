Growth.setup do |config|      
  # Default: Measures all models.
  # models_to_measure takes an array of Rails models as strings, for example:
  #
  # Growth.models_to_measure = [ 'User', 'Product', 'Order', 'Payment' ]
  
  # Default: Prevent specific models from being measured
  # model_blacklist takes an array of Rails models, for example:
  #
  # Growth.model_blacklist = [ AdminUser ]
  
  # This is your username for securing the '/growth' route
  # You will be prompted to enter this when viewing the page
  # This value would be better stored in an environment variabe
  #
  # Growth.username = ENV.fetch[:growth_username]
  
  # This is your password for securing the '/growth' route
  # You will be prompted to enter this when viewing the page
  # This value would be better stored in an environment variabe
  #
  # Growth.password = ENV.fetch[:growth_password]
end