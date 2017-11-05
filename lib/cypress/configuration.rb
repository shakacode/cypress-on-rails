module Cypress
  class Configuration
    attr_accessor :test_framework, :db_resetter, :cache_classes, :server_port

    def initialize(args=[])
      setup(args)
    end

    def setup(args)
      @args           = args
      @test_framework = :rspec
      @db_resetter    = :database_cleaner
      @before         = proc {}
      @cache_classes  = run_mode == 'run'
    end

    def include(mod)
      ScenarioContext.send :include, mod
    end

    def before(&block)
      if block_given?
        @before = block
      else
        @before
      end
    end

    def run_mode
      if @args.first == 'run'
        'run'
      else
        'open'
      end
    end

    def load_support
      require "./spec/cypress/cypress_helper"
    end
  end
end
