module Cypress
  class ScenarioBank
    def initialize
      @scenarios = {}
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
