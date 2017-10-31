module Cypress
  class Configuration
    attr_accessor :test_framework, :db_resetter, :cache_classes

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

    def cache_classes
      !! @cache_classes
    end

    def disable_class_caching
      if @cache_classes.nil?
        @cache_classes = false
      end
    end
  end
end
