module Cypress
  class Runner
    def initialize(args)
      @args          = args
      @scenario_bank = ScenarioBank.new
    end

    def run
      configuration.setup(@args)
      boot_rails
      Open3.popen2(*cypress_cli) do |sin, sout, status|
        sout.each_line do |line|
          puts "CYPRESS: #{line}"
        end
      end
    end

    private
      def configuration
        Cypress.configuration
      end

      def boot_rails
        require 'cypress/railtie'
        configuration.load_support
        require 'capybara/rails'

        Capybara.current_driver   = :selenium # oh, the irony....
        Capybara.server           = :puma
        configuration.server_port = Capybara.current_session.server.port
      end

      def cypress_cli
        result  = ['yarn', 'run']
        result += ['cypress', configuration.run_mode]
        result += ['--env', "SERVER_PORT=#{configuration.server_port}"]
        result += ['-c', 'videosFolder=spec/cypress/videos,fixturesFolder=spec/cypress/fixtures,integrationFolder=spec/cypress/integrations/,supportFile=spec/cypress/support/setup.js']
        result
      end
  end
end
