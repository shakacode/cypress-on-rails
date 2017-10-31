require 'active_support/dependencies/autoload'

module Cypress
  extend ActiveSupport::Autoload
  
  autoload :Server,         'cypress/server'
  autoload :CallbackServer, 'cypress/callback_server'
  autoload :Runner,         'cypress/runner'
  autoload :ScenarioBank,   'cypress/scenario_bank'
  autoload :Configuration,  'cypress/configuration'

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure(&block)
    yield configuration if block_given?
  end
end

if defined?(Rails)
  require_relative './cypress/railtie'
end
