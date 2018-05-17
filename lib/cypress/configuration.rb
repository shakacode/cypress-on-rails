module Cypress
  class Configuration
    attr_accessor :cypress_folder

    def initialize
      self.cypress_folder = 'spec/cypress'
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure(&block)
    yield configuration if block_given?
  end
end
