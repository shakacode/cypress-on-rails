module Cypress
  class Configuration
    attr_accessor :test_framework, :db_resetter

    def initialize
      @test_framework = :rspec
      @db_resetter    = :database_cleaner
      @before         = proc {}
    end

    def before(&block)
      if block_given?
        @before = block
      else
        @before
      end
    end
  end
end
