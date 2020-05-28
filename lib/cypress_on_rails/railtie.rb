require 'rails/railtie'
require 'cypress_on_rails/configuration'
require 'cypress_on_rails/middleware'

module CypressOnRails
  class Railtie < Rails::Railtie
    initializer :setup_cypress_middleware, after: :load_config_initializers do |app|
      if CypressOnRails.configuration.use_middleware?
        app.middleware.use Middleware
      end
    end
  end
end
