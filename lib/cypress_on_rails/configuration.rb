require 'logger'

module CypressOnRails
  class Configuration
    attr_accessor :cypress_folder
    attr_accessor :use_middleware
    attr_accessor :use_vcr_middleware
    attr_accessor :logger

    def initialize
      reset
    end

    alias :use_middleware? :use_middleware
    alias :use_vcr_middleware? :use_vcr_middleware

    def reset
      self.cypress_folder = 'spec/cypress'
      self.use_middleware = true
      self.use_vcr_middleware = false
      self.logger = Logger.new(STDOUT)
    end

    def tagged_logged
      if logger.respond_to?(:tagged)
        logger.tagged('CY_DEV') { yield }
      else
        yield
      end
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield configuration if block_given?
  end
end
