require 'cypress_on_rails/configuration'
require 'cypress_on_rails/simple_rails_factory'

module CypressOnRails
  class SmartFactoryWrapper
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
                   kernel: Kernel, file_system: File, dir_system: Dir)
      self.files = files
      self.factory = factory
      factory.definition_file_paths = []
      self.always_reload = always_reload
      @kernel = kernel
      @file_system = file_system
      @latest_mtime = nil
      @dir_system = dir_system
    end

    def create(*options)
      load_files
      factory_name = options.shift
      if options.last.is_a?(Hash)
        args = options.pop
      else
        args = {}
      end
      factory.create(factory_name,*options.map(&:to_sym),args.symbolize_keys)
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
      CypressOnRails.configuration.logger
    end

    def load_files
      current_latest_mtime = files.map{|file| @file_system.mtime(file) }.max
      return unless should_reload?(current_latest_mtime)
      logger.info 'Loading Factories'
      @latest_mtime = current_latest_mtime
      factory.reload
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