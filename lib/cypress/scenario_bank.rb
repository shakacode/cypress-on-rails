module Cypress
  class ScenarioBank
    def initialize
      @scenarios = {}
    end

    def boot
      if Cypress.configuration.test_framework == :rspec
        require 'rspec/rails'
        extend RSpec::Mocks::ExampleMethods
      end
    end

    def load
      Dir['./spec/cypress/scenarios/**/*.rb'].each do |f|
        instance_eval(File.read(f), f)
      end
    end

    def scenario(name, &block)
      @scenarios[name] = block
    end

    def [](name)
      @scenarios[name.to_sym]
    end
  end
end
