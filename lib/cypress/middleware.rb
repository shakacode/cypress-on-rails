require 'json'

module Cypress
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      if env['REQUEST_PATH'].to_s.starts_with?('/__cypress__/')
        path = env['REQUEST_PATH'].sub('/__cypress__/', '')
        cmd  = path.split('/').first
        if respond_to?("handle_#{cmd}", true)
          send "handle_#{cmd}", Rack::Request.new(env)
          [201, {}, ["success"]]
        else
          [404, {}, ["unknown command: #{cmd}"]]
        end
      else
        @app.call(env)
      end
    end

    private
      def configuration
        Cypress.configuration
      end

      def new_context
        ScenarioContext.new(configuration)
      end

      def handle_setup(req)
        reset_rspec           if configuration.test_framework == :rspec
        call_database_cleaner if configuration.db_resetter    == :database_cleaner
        new_context.execute configuration.before
      end

      def reset_rspec
        require 'rspec/rails'
        RSpec::Mocks.teardown
        RSpec::Mocks.setup
      end

      def call_database_cleaner
        require 'database_cleaner'
        DatabaseCleaner.strategy = :truncation
        DatabaseCleaner.clean
      end

      def json_from_body(req)
        JSON.parse(req.body.read)
      end

      def handle_scenario(req)
        handle_setup(req)

        @scenario_bank = ScenarioBank.new
        @scenario_bank.load
        if block = @scenario_bank[json_from_body(req)['scenario']]
          new_context.execute block
        end
      end

      def handle_eval(req)
        new_context.execute json_from_body(req)['code']
      end
  end
end
