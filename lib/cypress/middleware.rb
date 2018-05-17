require 'json'
require 'rack'
require 'cypress/configuration'

module Cypress
  # Middleware to handle cypress commands and eval
  class Middleware
    def initialize(app, kernel = ::Kernel, file = ::File)
      @app = app
      @kernel = kernel
      @file = file
    end

    def call(env)
      request = Rack::Request.new(env)
      if request.path.start_with?('/__cypress__/command')
        handle_command(request)
      elsif request.path.to_s.start_with?('/__cypress__/eval')
        handle_eval(request)
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

    def json_from_body(req)
      JSON.parse(req.body.read)
    end

    def handle_command(req)
      name = json_from_body(req).fetch('name')
      file_path = "#{configuration.cypress_folder}/app_commands/#{name}.rb"
      if @file.exists?(file_path)
        @kernel.load(file_path)
        [201, {}, ['success']]
      else
        [404, {}, ["could not find command file: #{file_path}"]]
      end
    end

    def handle_eval(req)
      result = @kernel.eval(json_from_body(req).fetch('code'))
      [201, {}, [result.to_s]]
    end
  end
end
