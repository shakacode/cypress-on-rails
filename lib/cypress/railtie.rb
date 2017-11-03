require 'rails/railtie'
module Cypress
  class Railtie < Rails::Railtie
    initializer :inject_cypress_middleware do |app|
      app.middleware.use Middleware
    end

    generators do
      require_relative '../generators/install_generator'
    end
  end
end
