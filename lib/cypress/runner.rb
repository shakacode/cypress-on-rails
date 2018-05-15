require 'thor'
require 'open3'

module Cypress
  class Runner < ::Thor
    desc 'open', 'starts rails server and run'
    method_option :rails_bin, desc: 'where bin/rails is', default: 'bin/rails', type: :string
    def open
      boot_rails
      start_cypress('open')
    end

    desc 'ci', 'starts rails server and run'
    method_option :rails_bin, desc: 'where bin/rails is', default: 'bin/rails', type: :string
    def ci
      boot_rails
      start_cypress('run')
    end

    private

      def configuration
        require './config/initializers/cypress_on_rails'
        Cypress.configuration
      end

      def boot_rails
        Open3.popen2(*rails_server) do |sin, sout, status|
          sout.each_line do |line|
            puts "RAILS: #{line}"
          end
        end
      end

      def rails_server
        [options.rails_bin, 'server', '-p', '5002']
      end

      def start_cypress(run_mode)
        Open3.popen2(*cypress_cli(run_mode)) do |sin, sout, status|
          sout.each_line do |line|
            puts "CYPRESS: #{line}"
          end
        end
      end

      def cypress_cli(run_mode)
        ['yarn', 'run', '--cwd=spec',
         'cypress', run_mode]
      end
  end
end
