require 'active_support/dependencies/autoload'

module Cypress
  extend ActiveSupport::Autoload

  autoload :Runner,          'cypress/runner'
  autoload :ScenarioBank,    'cypress/scenario_bank'
  autoload :ScenarioContext, 'cypress/scenario_context'
  autoload :Configuration,   'cypress/configuration'
  autoload :Middleware,      'cypress/middleware'

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure(&block)
    yield configuration if block_given?
  end

  def self.run_middleware?
    Rails.env.test?
  end
end

if defined?(Rails)
  require_relative './cypress/railtie'
end
