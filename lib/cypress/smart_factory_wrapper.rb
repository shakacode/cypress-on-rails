require 'cypress/configuration'
require 'cypress/simple_rails_factory'

module Cypress
  class SmartFactoryWrapper
    module FactoryCleaner
      def self.clean(f = FactoryBot)
        f.factories.clear if f.respond_to?(:factories)
        f.traits.clear if f.respond_to?(:traits)
        f.callbacks.clear if f.respond_to?(:callbacks)
        f.sequences.clear if f.respond_to?(:sequences)
      end
    end

    def self.instance
      @instance ||= new(files: [], factory: SimpleRailsFactory)
    end

    def self.configure(files:, factory:)
      @instance = new(files: files, factory: factory)
    end

    def self.create(*args)
      instance.create(*args)
    end

    def self.create_list(*args)
      instance.create_list(*args)
    end

    # @return [Array]
    attr_accessor :files
    attr_accessor :factory

    def initialize(files:, factory:,
                   factory_cleaner: FactoryCleaner, kernel: Kernel, file_system: File)
      self.files = files
      self.factory = factory
      @kernel = kernel
      @file_system = file_system
      @factory_cleaner = factory_cleaner
      @latest_mtime = nil
    end

    def create(*args)
      load_files
      factory.create(*args)
    end

    def create_list(*args)
      load_files
      factory.create_list(*args)
    end

    private

    def logger
      Cypress.configuration.logger
    end

    def load_files
      current_latest_mtime = files.map{|file| @file_system.mtime(file) }.max
      if @latest_mtime.nil? || @latest_mtime < current_latest_mtime
        logger.info 'Loading Factories'
        @latest_mtime = current_latest_mtime
        @factory_cleaner.clean(factory)
        files.each do |file|
          logger.debug "-- Loading: #{file}"
          @kernel.load(file)
        end
      end
    end
  end
end