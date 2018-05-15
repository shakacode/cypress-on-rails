require 'rails/railtie'
module Cypress
  class Railtie < Rails::Railtie
    initializer :setup_cypress_middleware do |app|
      if Cypress.run_middleware?
        app.middleware.use Middleware
      end
    end
  end
end
