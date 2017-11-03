module Cypress
  class Server
    def initialize(args)
      @args          = args
      @runner        = Runner.new self
      @scenario_bank = ScenarioBank.new
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
      @runner.run server_port
    end

    private
      def configuration
        Cypress.configuration
      end

      def boot_rails
        configuration.disable_class_caching if mode == 'open'
        require 'cypress/railtie'
        require "./spec/cypress/cypress_helper"
        require 'capybara/rails'

        Capybara.current_driver = :selenium # oh, the irony....
        Capybara.server         = :puma
        Capybara.current_session.server.port
      end
  end
end
