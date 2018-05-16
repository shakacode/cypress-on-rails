require 'json'

module Cypress
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      if env['REQUEST_PATH'].to_s.starts_with?('/__cypress__/command')
        request = Rack::Request.new(env)
        handle_command(request)
      elsif env['REQUEST_PATH'].to_s.starts_with?('/__cypress__/eval')
        request = Rack::Request.new(env)
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
        if File.exists?(file_path)
          load(file_path)
          [201, {}, ["success"]]
        else
          [404, {}, ["could not find command file: #{file_path}"]]
        end
      end

      def handle_eval(req)
        result = eval(json_from_body(req).fetch('code'))
        [200,
         { 'Content-Type' => 'text/plain' },
         [result.to_s]]
      end
  end
end
