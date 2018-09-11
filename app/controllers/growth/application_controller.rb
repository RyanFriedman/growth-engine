module Growth
  class ApplicationController < ActionController::Base
    http_basic_authenticate_with name: Growth.username, password: Growth.password unless Rails.env.test?

    protect_from_forgery with: :exception
  end
end
