require 'json'
require 'rack'
require 'cypress/configuration'
require 'cypress/command_executor'

module Cypress
  # Middleware to handle cypress commands and eval
  class Middleware
    def initialize(app, command_executor = CommandExecutor, file = ::File)
      @app = app
      @command_executor = command_executor
      @file = file
    end

    def call(env)
      request = Rack::Request.new(env)
      if request.path.start_with?('/__cypress__/command')
        handle_command(request)
      else
        @app.call(env)
      end
    end

    private

    def configuration
      Cypress.configuration
    end

    def cypress_folder
      configuration.cypress_folder
    end

    def handle_command(req)
      body = JSON.parse(req.body.read)
      configuration.logger.info "Cypress#handle_command: #{body}"
      name = body.fetch('name')
      options = body['options']
      file_path = "#{configuration.cypress_folder}/app_commands/#{name}.rb"
      if @file.exists?(file_path)
        require_cypress_helper
        @command_executor.load(file_path, options)
        [201, {}, ['success']]
      else
        [404, {}, ["could not find command file: #{file_path}"]]
      end
    end

    def require_cypress_helper
      cypress_helper_file = "#{configuration.cypress_folder}/cypress_helper"
      if File.exists?("#{cypress_helper_file}.rb")
        require cypress_helper_file
      end
    end
  end
end
