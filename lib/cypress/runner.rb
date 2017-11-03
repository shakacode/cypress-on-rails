module Cypress
  class Runner
    def initialize(owner)
      @owner = owner
    end

    def run(server_port)
      Open3.popen2(*cypress_cli(server_port)) do |sin, sout, status|
        sout.each_line do |line|
          puts "CYPRESS: #{line}"
        end
      end
    end

    private
      def cypress_cli(server_port)
        result  = ['yarn', 'run']
        result += ['cypress', @owner.mode]
        result += ['--env', "SERVER_PORT=#{server_port}"]
        result += ['-c', 'videosFolder=spec/cypress/videos,fixturesFolder=spec/cypress/fixtures,integrationFolder=spec/cypress/integrations/,supportFile=spec/cypress/support/setup.js']
        result
      end
  end
end
