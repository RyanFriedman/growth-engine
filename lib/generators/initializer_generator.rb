class InitializerGenerator < Rails::Generators::Base
  def create_initializer_file
    create_file "config/initializers/growth.rb", "# Add initialization content here"
  end
end