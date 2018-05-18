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

    def handle_command(req)
      body = JSON.parse(req.body.read)
      configuration.logger.info "Cypress#handle_command: #{body}"
      name = body.fetch('name')
      options = body['options']
      file_path = "#{configuration.cypress_folder}/app_commands/#{name}.rb"
      if @file.exists?(file_path)
        @command_executor.load(file_path, options)
        [201, {}, ['success']]
      else
        [404, {}, ["could not find command file: #{file_path}"]]
      end
    end
  end
end
