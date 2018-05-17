require 'active_support/dependencies/autoload'

require 'cypress/configuration'

module Cypress
  extend ActiveSupport::Autoload

  autoload :Runner,          'cypress/runner'
  autoload :Middleware,      'cypress/middleware'

  def self.run_middleware?
    Rails.env.test?
  end
end

if defined?(Rails)
  require_relative './cypress/railtie'
end
