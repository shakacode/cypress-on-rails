require 'json'
require 'rack'
require 'cypress_on_rails/middleware_config'
require 'cypress_on_rails/command_executor'

module CypressOnRails
  # Middleware to handle cypress commands and eval
  class Middleware
    include MiddlewareConfig

    def initialize(app, command_executor = CommandExecutor, file = ::File)
      @app = app
      @command_executor = command_executor
      @file = file
    end

    def call(env)
      request = Rack::Request.new(env)
      if request.path.start_with?('/__cypress__/command')
        configuration.tagged_logged { handle_command(request) }
      else
        @app.call(env)
      end
    end

    private

    Command = Struct.new(:name, :options, :cypress_folder) do
      # @return [Array<Cypress::Middleware::Command>]
      def self.from_body(body, configuration)
        if body.is_a?(Array)
          command_params = body
        else
          command_params = [body]
        end
        command_params.map do |params|
          new(params.fetch('name'), params['options'], configuration.cypress_folder)
        end
      end

      def file_path
        "#{cypress_folder}/app_commands/#{name}.rb"
      end
    end

    def handle_command(req)
      body = JSON.parse(req.body.read)
      logger.info "handle_command: #{body}"
      commands = Command.from_body(body, configuration)
      missing_command = commands.find {|command| !@file.exist?(command.file_path) }

      if missing_command.nil?
        begin
          results = commands.map { |command| @command_executor.perform(command.file_path, command.options) }

          begin
            output = results.to_json
          rescue NoMethodError
            output = {"message" => "Cannot convert to json"}.to_json
          end

          logger.debug "output: #{output}"
          [201, {'Content-Type' => 'application/json'}, [output]]
        rescue => e
          output = {"message" => e.message, "class" => e.class.to_s}.to_json
          [500, {'Content-Type' => 'application/json'}, [output]]
        end
      else
        output = {"message" => "could not find command file: #{missing_command.file_path}"}.to_json
        [404, {'Content-Type' => 'application/json'}, [output]]
      end
    end
  end
end
