module Cypress
  class Runner
    def initialize(callback_url)
      @callback_url = callback_url
    end

    def run(server_port)
      puts 'run'
      Open3.popen2(*cypress_cli(server_port)) do |sin, sout, status|
        sout.each_line do |line|
          puts "CYPRESS: #{line}"
        end
      end
    end

    private
      def cypress_cli(server_port)
        result  = ['yarn', 'run']
        result += ['cypress', 'open']
        result += ['--env', "SERVER_PORT=#{server_port}"]
        result += ['--env', "CALLBACK=#{@callback_url}"]
        result += ['-c', 'fixturesFolder=spec/cypress/fixtures,integrationFolder=spec/cypress/integrations/,supportFile=spec/cypress/support/setup.js']
        result
      end
  end
end
