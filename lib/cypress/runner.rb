module Cypress
  class Runner
    def initialize(args, callback_url)
      @args         = args
      @callback_url = callback_url
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
        result += ['cypress', mode]
        result += ['--env', "SERVER_PORT=#{server_port},CALLBACK=#{@callback_url}"]
        result += ['-c', 'videosFolder=spec/cypress/videos,fixturesFolder=spec/cypress/fixtures,integrationFolder=spec/cypress/integrations/,supportFile=spec/cypress/support/setup.js']
        result
      end

      def mode
        if @args.first == 'run'
          'run'
        else
          'open'
        end
      end
  end
end
