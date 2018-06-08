require 'rails/railtie'
require 'cypress_dev/configuration'
require 'cypress_dev/middleware'

module CypressDev
  class Railtie < Rails::Railtie
    initializer :setup_cypress_middleware do |app|
      if CypressDev.configuration.use_middleware?
        app.middleware.use Middleware
      end
    end
  end
end
