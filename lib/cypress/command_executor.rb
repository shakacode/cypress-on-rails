require 'cypress/configuration'

module Cypress
  # Middleware to handle cypress commands and eval
  class CommandExecutor
    def self.load(file,command_options = nil)
      load_cypress_helper
      file_data = File.read(file)
      eval file_data
    rescue => e
      logger.error("fail to execute #{file}: #{e.message}")
      raise e
    end

    def self.load_cypress_helper
      cypress_helper_file = "#{configuration.cypress_folder}/cypress_helper"
      if File.exist?("#{cypress_helper_file}.rb")
        Kernel.require cypress_helper_file
      else
        logger.warn "could not find #{cypress_helper_file}.rb"
      end
    end

    def self.logger
      configuration.logger
    end

    def self.configuration
      Cypress.configuration
    end
  end
end
