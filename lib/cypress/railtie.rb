require 'rails/railtie'
require 'cypress/configuration'
require 'cypress/middleware'

module Cypress
  class Railtie < Rails::Railtie
    initializer :setup_cypress_middleware do |app|
      if Cypress.configuration.use_middleware?
        app.middleware.use Middleware
      end
    end
  end
end
