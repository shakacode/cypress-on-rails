require 'json'
require 'rack'
require 'cypress_on_rails/configuration'

module CypressOnRails
  module MiddlewareConfig
    protected

    def configuration
      CypressOnRails.configuration
    end

    def logger
      configuration.logger
    end
  end
end
