require 'rails/railtie'
module Cypress
  class Railtie < Rails::Railtie
    initializer :setup_cypress_middleware do |app|
      if Cypress.run_middleware?
        Cypress.configuration.load_support
        app.middleware.use Middleware
      end
    end
  end
end
