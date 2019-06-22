Growth.setup do |config|      
  # Default: Measures all models.
  # models_to_measure takes an array of Rails models, for example:
  #
  Growth.models_to_measure = [ 'Customer', 'Product', 'LineItem', 'Order', 'Payment']
  
  # Default: Prevent specific models from being measured
  # model_blacklist takes an array of Rails models, for example:
  #
  # Growth.model_blacklist = [ 'AdminUser' ]
  
  # This is your username for securing the '/stats' URL
  # You will be prompted to enter this when viewing the page
  # This value would be better stored in an environment variable
  #
  Growth.username = 'stats'
  
  # This is your password for securing the /stats page
  # You will be prompted to enter this when viewing the page
  # This value would be better stored in an environment variable
  #
  Growth.password = 'password'
end