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

      @callback_thread = Thread.new { @callback_server.start }
      @runner_thread   = Thread.new { @runner.run server_port }
      @runner_thread.join

      @callback_server.shutdown
    end

    def run_command(command)
      @scenario_bank.load

      if command['scenario'] and (block = @scenario_bank[command['scenario']])
        block.call
      end
    end

    private
      def boot_rails
        ENV['RAILS_ENV'] ||= 'test'
        require './config/environment'
        require 'capybara/rails'

        Capybara.current_driver = :selenium # oh, the irony....
        Capybara.current_session.server.port
      end
  end
end
