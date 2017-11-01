module Cypress
  class Server
    def initialize(args)
      @args            = args
      @callback_server = CallbackServer.new(self)
      @runner          = Runner.new self, @callback_server.callback_url
      @scenario_bank   = ScenarioBank.new
    end

    def mode
      if @args.first == 'run'
        'run'
      else
        'open'
      end
    end

    def run
      server_port = boot_rails

      @callback_thread = Thread.new { @callback_server.start }
      @runner_thread   = Thread.new { @runner.run server_port }
      @runner_thread.join

      @callback_server.shutdown
    end

    def run_command(command, options={})
      if respond_to?("run_command_#{command}", true)
        send "run_command_#{command}", options
      end
    end

    private
      def configuration
        Cypress.configuration
      end

      def boot_rails
        configuration.disable_class_caching if mode == 'open'
        require "./spec/cypress/cypress_helper"
        require 'capybara/rails'

        Capybara.current_driver = :selenium # oh, the irony....
        Capybara.current_session.server.port
      end

      def run_command_setup(options={})
        reset_rspec           if configuration.test_framework == :rspec
        call_database_cleaner if configuration.db_resetter    == :database_cleaner
        new_context.execute configuration.before
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

      def run_command_scenario(options={})
        run_command_setup

        @scenario_bank.load
        if block = @scenario_bank[options['scenario']]
          new_context.execute block
        end
      end

      def run_command_eval(options={})
        new_context.execute options['code']
      end

      def new_context
        ScenarioContext.new(configuration)
      end
  end
end
