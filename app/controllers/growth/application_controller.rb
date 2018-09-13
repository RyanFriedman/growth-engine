module Growth
  class ApplicationController < ActionController::Base
    http_basic_authenticate_with name: Growth.username, password: Growth.password unless Rails.env.test?

    protect_from_forgery with: :exception

    def pluralize_constant(constant)
      constant.to_s.pluralize
    end
    helper_method :pluralize_constant
  end
end
