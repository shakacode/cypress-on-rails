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
          begin
            send "handle_#{cmd}", Rack::Request.new(env)
          rescue => e
            STDERR.puts e.message
            [500, {}, [e.message]]
          end
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

      def cypress_folder
        configuration.cypress_folder
      end

      def json_from_body(req)
        JSON.parse(req.body.read)
      end

      def handle_ping(req)
        [200,
         { 'Content-Type' => 'text/html' },
         ['<html><body>Hello Cypress on Rails</body></html>']]
      end

      def handle_command(req)
        name = json_from_body(req).fetch('name')
        c = File.open("#{configuration.cypress_folder}/app_commands/#{name}.rb") {|f| f.read }
        eval(c)
        [201, {}, ["success"]]
      end

      def handle_eval(req)
        result = eval(json_from_body(req).fetch('code'))
        [200,
         { 'Content-Type' => 'text/plain' },
         [result.to_s]]
      end
  end
end
