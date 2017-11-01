module Cypress
  class ScenarioContext
    def initialize(configuration)
      if configuration.test_framework == :rspec
        setup_rspec
      end
    end

    def execute(block_or_code)
      if block_or_code.is_a? Proc
        instance_eval &block_or_code
      else
        instance_eval block_or_code
      end
    end

    private
      def setup_rspec
        require 'rspec/rails'
        extend RSpec::Mocks::ExampleMethods
      end
  end
end
