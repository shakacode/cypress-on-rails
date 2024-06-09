require 'rails/railtie'
require 'cypress_on_rails/configuration'

module CypressOnRails
  class Railtie < Rails::Railtie
    initializer :setup_cypress_middleware, after: :load_config_initializers do |app|
      if CypressOnRails.configuration.use_middleware?
        require 'cypress_on_rails/middleware'
        app.middleware.use Middleware
      end
      if CypressOnRails.configuration.use_vcr_middleware?
        require 'cypress_on_rails/vcr_middleware'
        app.middleware.use VCRMiddleware
      end
    end
  end
end
