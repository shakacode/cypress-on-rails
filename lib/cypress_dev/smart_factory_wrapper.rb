require 'cypress_dev/configuration'
require 'cypress_dev/simple_rails_factory'

module CypressDev
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

    def self.configure(files:, factory:, always_reload: true)
      @instance = new(files: files, factory: factory, always_reload: always_reload)
    end

    def self.create(*args)
      instance.create(*args)
    end

    def self.create_list(*args)
      instance.create_list(*args)
    end

    # @return [Array]
    attr_accessor :factory
    attr_accessor :always_reload

    def initialize(files:, factory:, always_reload: false,
                   factory_cleaner: FactoryCleaner, kernel: Kernel, file_system: File,
                   dir_system: Dir)
      self.files = files
      self.factory = factory
      self.always_reload = always_reload
      @kernel = kernel
      @file_system = file_system
      @factory_cleaner = factory_cleaner
      @latest_mtime = nil
      @dir_system = dir_system
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

    # @param [String,Array] arg
    def files=(array)
      array = [array] if array.is_a?(String)
      @dir_array = array
    end

    # @return [Array<String>]
    def files
      Dir[*@dir_array]
    end

    def logger
      CypressDev.configuration.logger
    end

    def load_files
      current_latest_mtime = files.map{|file| @file_system.mtime(file) }.max
      return unless should_reload?(current_latest_mtime)
      logger.info 'Loading Factories'
      @latest_mtime = current_latest_mtime
      @factory_cleaner.clean(factory)
      files.each do |file|
        logger.debug "-- Loading: #{file}"
        @kernel.load(file)
      end
    end

    def should_reload?(current_latest_mtime)
      @always_reload || @latest_mtime.nil? || @latest_mtime < current_latest_mtime
    end
  end
end