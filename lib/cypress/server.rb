require 'webrick'
require 'json'

module Cypress
  class Server
    def initialize
      @callback_server = CallbackServer.new(self)
      @runner          = Runner.new @callback_server.callback_url
      @scenario_bank   = ScenarioBank.new
    end

    def run
      server_port = boot_rails
      load_cypress_helper
      @scenario_bank.boot

      @callback_thread = Thread.new { @callback_server.start }
      @runner_thread   = Thread.new { @runner.run server_port }
      @runner_thread.join

      @callback_server.shutdown
    end

    def run_command(command)
      @scenario_bank.load

      if command['scenario'] and (block = @scenario_bank[command['scenario']])
        reset_rspec           if configuration.test_framework == :rspec
        call_database_cleaner if configuration.db_resetter    == :database_cleaner
        configuration.before.call

        block.call
      end
    end

    private
      def configuration
        Cypress.configuration
      end

      def boot_rails
        ENV['RAILS_ENV'] ||= 'test'
        require './config/environment'
        require 'capybara/rails'

        Capybara.current_driver = :selenium # oh, the irony....
        Capybara.current_session.server.port
      end

      def load_cypress_helper
        require "./spec/cypress/cypress_helper"
      end

      def reset_rspec
        RSpec::Mocks.teardown
        RSpec::Mocks.setup
      end

      def call_database_cleaner
        require 'database_cleaner'
        DatabaseCleaner.strategy = :truncation
        DatabaseCleaner.clean
      end
  end
end
